//
//  ContentView.swift
//  MasterExpense
//
//  Created by Brian Quick on 2026-01-24.
//

import SwiftUI
internal import UniformTypeIdentifiers

struct MasterView: View {
    @EnvironmentObject var expense: ExpenseModel
    @EnvironmentObject var head: HeadingModel
    var body: some View {
        VStack {
            
                
            List(expense.expenses) { expense in
                HStack {
                    Text(expense.year.description)
                    Text(expense.name)
                    Spacer()
                    Text("$\(expense.total, specifier: "%.2f")")
                    Text("$\(expense.average, specifier: "%.2f")")
                }
            }
        }
    }
}

#Preview {
    MasterView()
}
