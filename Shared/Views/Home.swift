//
//  Home.swift
//  habit_tracker (iOS)
//

import SwiftUI

struct Home: View {
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateAdded, ascending: false)],
        predicate: nil,
        animation: .easeInOut
    ) var habits: FetchedResults<Habit>
    
    @StateObject var habitModel: HabitViewModel = .init()
    
    var body: some View {
        VStack(spacing: 0){
            Text("Habits")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {

                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 12)
            
            ScrollView(
                habits.isEmpty
                    ? .init()
                    : .vertical
                , showsIndicators: false
            ){
                VStack(spacing: 15){
                    ForEach(habits){
                        habit in HabitCardView(habit: habit)
                    }
                    // Add Habits Button
                    Button {
                        habitModel.addNewHabit.toggle()
                    } label: {
                        Label {
                            Text("New Habit")
                        } icon: {
                            Image(systemName: "plus.circle")
                        }
                        .font(.callout.bold())
                        .foregroundColor(.white)
                    }
                    .padding(.top, 15)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                }
                .padding(.vertical)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .sheet(isPresented: $habitModel.addNewHabit){
            
        } content: {
            AddNewHabit()
                .environmentObject(habitModel)
        }
    }
    
    @ViewBuilder
    func HabitCardView(habit: Habit) -> some View {
        VStack(spacing: 12){
            HStack{
                Text(habit.title ?? "")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Image(systemName: "bell.badge.fill")
                    .font(.callout)
                    .foregroundColor(Color(habit.color ?? "red"))
                    .scaleEffect(0.9)
                    .opacity(habit.reminderOn ? 1 : 0)
                
                Spacer()
                
                let count = (habit.weekDays?.count ?? 0)
                Text(
                    count == 7
                        ? "Everyday"
                        : count == 1
                            ? "\(count) time a week"
                            : "\(count) times a week"
                )
                    .font(.caption)
                    .foregroundColor(.gray)
                
                let calendar = Calendar.current
                let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: Date())
                let daySymbols = calendar.weekdaySymbols
                let startDay = currentWeek?.start ?? Date()
                let activeWeekDays = habit.weekDays ?? []
                let activePlot = daySymbols.indices.compactMap {
                    index -> (String, Date) in
                    let currentDate = calendar.date(byAdding: .day, value: index, to: startDay)
                    return (daySymbols[index], currentDate!)
                }
                
                HStack(spacing: 15) {
                    ForEach(activePlot.indices, id: \.self){
                        index in
                        let item = activePlot[index]
                        
                        VStack(spacing: 9) {
                            Text(item.0.prefix(3))
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            let status = activeWeekDays.contains {
                                day in
                                return day == item.0
                            }
                            
                            Text(formatDate(date: item.1))
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .padding(9)
                                .background {
                                    Circle()
                                        .fill(Color(habit.color ?? "red"))
                                        .opacity(status ? 1 : 0)
                                    
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 12)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("black").opacity(0.6))
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        return dateFormatter.string(from: date)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
