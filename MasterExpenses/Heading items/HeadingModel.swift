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
//        print("Loaded: \(headings.map { $0.name })")

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
    func headingForName(_ name: String) -> Heading? {
        headings.first { $0.name == name }
    }
    func updateHeading(name: String, expense: Bool, tracking: Bool) {
        headings = headings.map {
            if $0.name == name {
                return Heading(name: $0.name, expense: expense, tracking: tracking)
            } else {
                return $0
            }
        }
    }
}

struct HeadingTogglesView: View {
    let name: String
    @EnvironmentObject var head: HeadingModel

    var body: some View {
        let heading = head.headingForName(name)
        let expenseValue = heading?.expense ?? false
        let trackingValue = heading?.tracking ?? false

        HStack {
            Toggle(
                "",
                isOn: Binding(
                    get: { expenseValue },
                    set: { newValue in
                        head.updateHeading(
                            name: name,
                            expense: newValue,
                            tracking: trackingValue
                        )
                        head.save()
                    }
                )
            )
            .labelsHidden()
            .toggleStyle(.switch)
            .frame(minWidth: 0, alignment: .leading)
            Text(expenseValue ? "Expense" : "Income")

            Toggle(
                "",
                isOn: Binding(
                    get: { trackingValue },
                    set: { newValue in
                        head.updateHeading(
                            name: name,
                            expense: expenseValue,
                            tracking: newValue
                        )
                        head.save()
                    }
                )
            )
            .labelsHidden()
            .toggleStyle(.switch)
            .frame(minWidth: 0, alignment: .leading)
            Text("Tracking")
        }
    }
}
