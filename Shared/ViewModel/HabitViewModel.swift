//
//  HabitViewModel.swift
//  habit_tracker (iOS)
//

import SwiftUI
import CoreData
import UserNotifications

class HabitViewModel: ObservableObject {
    // New Habit Entity
    @Published var addNewHabit: Bool = false
    @Published var title: String = ""
    @Published var habitColor: String = "red"
    @Published var weekDays: [String] = []
    @Published var reminderOn: Bool = false
    @Published var reminderText: String = ""
    @Published var reminderTime: Date = Date()
    @Published var showTimePicker: Bool = false
    @Published var editHabit: Habit?
    
    // Add Habit
    func addHabit(context: NSManagedObjectContext) async -> Bool{
        let habit = Habit(context: context)
        habit.title = title
        habit.color = habitColor
        habit.weekDays = weekDays
        habit.reminderOn = reminderOn
        habit.reminderText = reminderText
        habit.notificationTime = reminderTime
        habit.notificationIDs = []
        
        if reminderOn {
            if let ids = try? await scheduleNotification(){
                habit.notificationIDs = ids
            }
            if let _ = try? context.save(){
                return true
            }
        } else {
            // Add Habit
            if let _ = try? context.save(){
                return true
            }
        }
        
        return false
    }
    
    // Button Status
    func doneStatus() -> Bool {
        let reminderStatus = reminderOn ? reminderText == "" : false
        
        if title == "" || weekDays.isEmpty || reminderStatus {
            return false
        }
        return true
    }
    
    // Edit Habit
    func populateHabitData(){
        if let editHabit = editHabit {
            title = editHabit.title ?? ""
            habitColor = editHabit.color ?? "red"
            weekDays = editHabit.weekDays ?? []
            reminderOn = editHabit.reminderOn
            reminderText = editHabit.reminderText ?? ""
            reminderTime = editHabit.notificationTime ?? Date()
        }
    }
        
    // Reset Data
    func resetData(){
        title = ""
        habitColor = "red"
        weekDays = []
        reminderOn = false
        reminderText = ""
        reminderTime = Date()
        editHabit = nil
    }
    
    // Schedule notification
    func scheduleNotification() async throws -> [String]{
        let notificationContent = UNMutableNotificationContent()
        let titleTemplate = "Habit Reminder For %@"
        notificationContent.title = String(format: titleTemplate, title)
        notificationContent.subtitle = reminderText
        notificationContent.sound = UNNotificationSound.default
        
        var notificationIDs: [String] = []
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.weekdaySymbols
        
        for weekday in weekDays {
            let id = UUID().uuidString
            let day = weekdaySymbols.firstIndex {
                currentDay in return currentDay == weekday
            } ?? -1
            let hour = calendar.component(.hour, from: reminderTime)
            let minute = calendar.component(.minute, from: reminderTime)
            
            if day != -1 {
                var components = DateComponents()
                components.weekday = day + 1
                components.hour = hour
                components.minute = minute
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let notificationRequest = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)
                try await UNUserNotificationCenter.current().add(notificationRequest)
                notificationIDs.append(id)
            }
        }
        
        return notificationIDs
    }
}
