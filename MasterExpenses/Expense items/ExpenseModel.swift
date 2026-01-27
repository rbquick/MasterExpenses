//
//  ExpenseModel.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-01-25.
//

import SwiftUI
import Combine

class ExpenseModel: ObservableObject {
    @Published var expenses: [Expense] = []
    
    internal init() {
        expenses = loadExpenses(from: "Expenses-master-spreadsheet")
    }
}
