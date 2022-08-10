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
                    // Add Habits Button
                    Button {
                        
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
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
