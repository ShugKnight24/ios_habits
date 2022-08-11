//
//  HabitViewModel.swift
//  habit_tracker (iOS)
//

import SwiftUI
import CoreData

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
}
