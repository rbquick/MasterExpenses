//
//  Heading.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-01-25.
//

import SwiftUI

struct Heading: Codable, Identifiable {
    let name: String
    let expense: Bool
    let tracking: Bool
    var id: String {
        "\(name)"
    }
    enum CodingKeys: String, CodingKey {
        case name, expense, tracking
    }
    internal init(name: String, expense: Bool, tracking: Bool) {
        self.name = name
        self.expense = expense
        self.tracking = tracking
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        expense = try container.decode(Bool.self, forKey: .expense)
        tracking = try container.decode(Bool.self, forKey: .tracking)
    }
}
extension Array where Element == Heading {
    /// All Heading records (returns self for convenience)
    var allRecords: [Heading] { self }
    /// All with expense == true
    var withExpense: [Heading] { filter { $0.expense } }
    /// All with expense == false
    var withoutExpense: [Heading] { filter { !$0.expense } }
    /// All with expense == true and tracking == true
    var withExpenseAndTracking: [Heading] { filter { $0.expense && $0.tracking } }
    /// All with expense == false and tracking == true
    var withoutExpenseWithTracking: [Heading] { filter { !$0.expense && $0.tracking } }
    /// Returns Headings whose name matches any Expense.name in the given expenses array
    func selected(from expenses: [Expense]) -> [Heading] {
        let expenseNames = Set(expenses.map { $0.name })
        return filter { expenseNames.contains($0.name) }
    }
}

// Now you can use these computed properties on any [Heading] array.

extension Array where Element == Expense {
    /// Returns Expense records whose name matches any Heading.name in the given headings array
    /// The newer method with filtering by years can cover both filtering needs.
    func selected(from headings: [Heading]) -> [Expense] {
        let headingNames = Set(headings.map { $0.name })
        return filter { headingNames.contains($0.name) }
    }
    /// Returns Expense records whose name matches any Heading.name in the given headings array, and year is 2024 or 2025
    func selected(from headings: [Heading], years: Set<Int> = [2024, 2025]) -> [Expense] {
        let headingNames = Set(headings.map { $0.name })
        return filter { headingNames.contains($0.name) && years.contains($0.year) }
    }
}
// Now you can use this method on any [Expense] array to filter expenses based on a set of headings.

