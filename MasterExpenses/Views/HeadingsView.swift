//
//  HeadingsView.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-01-26.
//

import SwiftUI

struct HeadingsView: View {
    
    @EnvironmentObject var expense: ExpenseModel 
    @EnvironmentObject var head: HeadingModel
    
    var body: some View {
        VStack {
                Button("Create Heading") {
                    createHeading()
            }
            Button("Save ") {
                head.save()
        }
            List(head.headings) { head in
                HStack {
                    
                    Text(head.name)
                    Spacer()
                    Text(head.tracking.description)
                    Text(head.expense.description)
                }
            }
        }
    }
}

#Preview {
    HeadingsView()
}
extension HeadingsView {
    func createHeading() {
        head.deleteAll( )
        // Get unique expense names, sorted alphabetically
        let uniqueNames = Set(expense.expenses.map { $0.name })
            .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        for name in uniqueNames {
            // Determine DR/CR based on total > 0 (expense = DR)
            let firstExpense = expense.expenses.first { $0.name == name }
            let expensetype = (firstExpense?.total ?? 0 > 0) ? true : false
            
            head.append(Heading(name: name, expense: expensetype, tracking: true))
        }
    }
}

