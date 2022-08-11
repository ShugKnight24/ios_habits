//
//  AddNewHabit.swift
//  habit_tracker (iOS)
//

import SwiftUI

struct AddNewHabit: View {
    @EnvironmentObject var habitModel: HabitViewModel
    var body: some View {
        NavigationView{
            VStack(spacing: 15){
                TextField("Title", text: $habitModel.title)
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
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add New Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .tint(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done") {
                        
                    }
                    .tint(.white)
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
