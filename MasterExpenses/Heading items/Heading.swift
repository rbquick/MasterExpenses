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
