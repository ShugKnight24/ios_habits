//
//  AddNewHabit.swift
//  habit_tracker (iOS)
//

import SwiftUI

struct AddNewHabit: View {
    @EnvironmentObject var habitModel: HabitViewModel
    @Environment(\.self) var env
    var body: some View {
        NavigationView{
            VStack(spacing: 15){
                TextField("Habit Name", text: $habitModel.title)
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(Color("black").opacity(0.6),
                        in: RoundedRectangle(cornerRadius: 9, style: .continuous)
                    )
                
                // Color Picker
                // TODO: Fix horizontal scrolling
                HStack(spacing: 0){
                    ForEach(1...7, id: \.self){
                        index in let color = "color-\(index)"
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .overlay(content: {
                                if color == habitModel.habitColor{
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                }
                            })
                            .onTapGesture {
                                withAnimation {
                                    habitModel.habitColor = color
                                }
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical)
                
                Divider()
                
                // Day Selection
                VStack(alignment: .leading, spacing: 6){
                    Text("Habit Schedule:")
                        .font(.callout.bold())

                    let weekDays = Calendar.current.weekdaySymbols
                    HStack(spacing: 10){
                        ForEach(weekDays, id: \.self){
                            day in
                            let isDaySelected = habitModel.weekDays.firstIndex {
                                currentDay in return currentDay == day
                            } ?? -1
                            
                            Text(day.prefix(3))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(isDaySelected != -1 ? Color(habitModel.habitColor) : Color("black").opacity(0.9))
                                }
                                .onTapGesture {
                                    withAnimation {
                                        if isDaySelected != -1 {
                                            habitModel.weekDays.remove(at: isDaySelected)
                                        } else {
                                            habitModel.weekDays.append(day)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.top, 9)
                }
                
                Divider()
                    .padding(.vertical, 15)
                
                // Reminders
                HStack {
                    VStack(alignment: .leading, spacing: 9) {
                        Text("Reminder")
                            .fontWeight(.semibold)
                        
                        Text(habitModel.reminderOn ? "Notifications On" : "Notifications Off")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Toggle(isOn: $habitModel.reminderOn) {}
                        .labelsHidden()
                }
                
                HStack(spacing: 12) {
                    Label {
                        Text(habitModel.reminderTime.formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(Color("black").opacity(0.6),
                        in: RoundedRectangle(cornerRadius: 9, style: .continuous)
                    )
                    .onTapGesture {
                        withAnimation {
                            habitModel.showTimePicker.toggle()
                        }
                    }
                    
                    TextField("Reminder Text", text: $habitModel.reminderText)
                        .padding(.horizontal)
                        .padding(.vertical, 15)
                        .background(Color("black").opacity(0.6),
                            in: RoundedRectangle(cornerRadius: 9, style: .continuous)
                        )
                }
                .frame(height: habitModel.reminderOn ? nil : 0)
                .opacity(habitModel.reminderOn ? 1 : 0)
            }
            .animation(.easeInOut, value: habitModel.reminderOn)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(habitModel.editHabit == nil ? "Add New Habit" : "Edit Habit")
            .toolbar {
                // Close out of Habit
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        env.dismiss()
                        habitModel.resetData()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .tint(.white)
                }
                
                // Delete Habit
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        if habitModel.deleteHabit(context: env.managedObjectContext){
                            env.dismiss()
                            habitModel.resetData()
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                    .opacity(habitModel.editHabit == nil ? 0 : 1 )
                }
                
                // Add Habit
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done") {
                        Task {
                            if await habitModel.addHabit(context: env.managedObjectContext){
                                env.dismiss()
                                habitModel.resetData()
                            }
                        }
                    }
                    .tint(.white)
                    .disabled(!habitModel.doneStatus())
                    .opacity(habitModel.doneStatus() ? 1 : 0.3)
                }
            }
        }
        .overlay {
            if habitModel.showTimePicker {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                habitModel.showTimePicker.toggle()
                            }
                        }
                    
                    DatePicker.init(
                        "",
                        selection: $habitModel.reminderTime,
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("black"))
                    }
                    .padding()
                }
            }
        }
    }
}

struct AddNewHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabit()
            .environmentObject(HabitViewModel())
            .preferredColorScheme(.dark)
    }
}
