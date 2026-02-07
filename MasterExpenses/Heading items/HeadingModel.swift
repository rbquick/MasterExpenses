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
    func headingIsTracked(_ name: String) -> Bool {
        headingForName(name)?.tracking ?? false
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

/// A SwiftUI `View` that displays toggle switches for a heading's
/// "expense" and "tracking" properties, allowing them to be modified interactively.
///
/// The toggles automatically persist changes via the `HeadingModel`'s `save()` method.
/// The label next to the first toggle updates between "Expense" and "Income"
/// based on the current expense state.
///
/// - Parameters:
///   - name: The name of the heading to present toggles for.
/// - EnvironmentObject:
///   - head: The shared `HeadingModel` that manages headings.
///
/// - Note:
///   If the specified heading cannot be found, default values (`false`) are used for both toggles.
///   Changes made in this view are immediately applied to the underlying model and persisted.
///
/// Typical usage:
/// ```swift
/// HeadingTogglesView(name: "Groceries")
///   .environmentObject(HeadingModel())
/// ```
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
