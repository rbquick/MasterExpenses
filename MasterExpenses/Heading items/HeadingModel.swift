//
//  HeadingModel.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-01-25.
//

import SwiftUI
import Combine

class HeadingModel: ObservableObject {
    @Published var headings: [Heading] = []
    
    internal init() {
        // Load
         headings = HeadingCSVManager.loadHeadings()
        print("Loaded: \(headings.map { $0.name })")

        // Modify & Save
//        var myHeadings = headings
//       headings.append(Heading(name: "New Category", expense: true, tracking: true))
//        try? HeadingCSVManager.saveHeadings(headings)

    }
    func save() {
        try? HeadingCSVManager.saveHeadings(headings)
    }
    func append(_ heading: Heading) {
        headings.append(heading)
//        save()
    }
    func deleteAll() {
        headings = []
        save()
    }
}
