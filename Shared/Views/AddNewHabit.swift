//
//  AddNewHabit.swift
//  habit_tracker (iOS)
//

import SwiftUI

struct AddNewHabit: View {
    @EnvironmentObject var habitModel: HabitViewModel
    var body: some View {
        VStack(spacing: 15){
            TextField("Title", text: $habitModel.title)
                .padding(.horizontal)
                .padding(.vertical, 15)
                .background(Color("black"),
                    in: RoundedRectangle(cornerRadius: 9, style: .continuous)
                )
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
}

struct AddNewHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabit()
            .environmentObject(HabitViewModel())
            .preferredColorScheme(.dark)
    }
}
