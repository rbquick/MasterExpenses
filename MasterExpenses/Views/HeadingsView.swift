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
    @Environment(\.selectedTab) var selectedTab
    
    @State private var searchText = ""
    
    var body: some View {
        VStack {

            List(head.headings.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { head in
                HStack {
                    
                    Text(head.name)
                    Spacer()
                    HeadingTogglesView(name: head.name)
                }
            }
            .searchable(text: $searchText, prompt: "Search name")
        }
    }
}

#Preview {
    HeadingsView()
        .environmentObject(ExpenseModel())
        .environmentObject(HeadingModel())
}
extension HeadingsView {
    // this is no longer required since the initial creation
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

