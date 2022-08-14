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
                Text(count == 7 ? "Everyday" : "\(count) times a week")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
