//
//  masterMonthsview.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-01-31.
//

import SwiftUI
struct masterMonthsview: View {
    
    var expense: Expense
    var showSign: Bool
    
    func displayValue(_ value: Double) -> String {
        value != 0 ? String(format: "%.2f", showSign ? value : -value) : ""
    }

    func isRed(_ value: Double) -> Bool {
        // showSign == true  && value < 0  → red
        // showSign == false && value > 0  → red
        (showSign && value < 0) || (!showSign && value > 0)
    }

    // Month labels and corresponding values
    private var months: [(label: String, value: Double)] {
        [
            ("Jan", expense.jan),
            ("Feb", expense.feb),
            ("Mar", expense.mar),
            ("Apr", expense.apr),
            ("May", expense.may),
            ("Jun", expense.jun),
            ("Jul", expense.jul),
            ("Aug", expense.aug),
            ("Sep", expense.sep),
            ("Oct", expense.oct),
            ("Nov", expense.nov),
            ("Dec", expense.dec)
        ]
    }
    
    var body: some View {
            ForEach(months, id: \.label) { month in
                VStack(alignment: .trailing) {
                    Text(month.label)
                        .frame(height: 15)
                    Text(displayValue(month.value))
                        .foregroundColor(isRed(month.value) ? .red : .primary)
                        .frame(height: 15)
                }
                .frame(maxWidth: .infinity)
            }
        
    }
}
    
//    var body: some View {
//        
//        
//            VStack(alignment: .trailing) {
//                Text("Jan").frame(height: 20)
//                Text(expense.jan != 0 ? "\(showSign ? expense.jan : -expense.jan, specifier: "%.02f")" : "")
//                    .frame(height: 20)
//                    .foregroundColor(isRed(expense.jan) ? .red : .primary)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Feb").frame(height: 20)
//                Text(expense.feb != 0 ? "\(showSign ? expense.feb : -expense.feb, specifier: "%.02f")" : "").frame(height: 20)
//                    .foregroundColor(isRed(expense.feb) ? .red : .primary)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Mar").frame(height: 20)
//                Text(expense.mar != 0 ? "\(showSign ? expense.mar : -expense.mar, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Apr").frame(height: 20)
//                Text(expense.apr != 0 ? "\(showSign ? expense.apr : -expense.apr, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("May").frame(height: 20)
//                Text(expense.may != 0 ? "\(showSign ? expense.may : -expense.may, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Jun").frame(height: 20)
//                Text(expense.jun != 0 ? "\(showSign ? expense.jun : -expense.jun, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Jul").frame(height: 20)
//                Text(expense.jul != 0 ? "\(showSign ? expense.jul : -expense.jul, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Aug").frame(height: 20)
//                Text(expense.aug != 0 ? "\(showSign ? expense.aug : -expense.aug, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Sep").frame(height: 20)
//                Text(expense.sep != 0 ? "\(showSign ? expense.sep : -expense.sep, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Oct").frame(height: 20)
//                Text(expense.oct != 0 ? "\(showSign ? expense.oct : -expense.oct, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Nov").frame(height: 20)
//                Text(expense.nov != 0 ? "\(showSign ? expense.nov : -expense.nov, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//            VStack(alignment: .trailing) {
//                Text("Dec").frame(height: 20)
//                Text(expense.dec != 0 ? "\(showSign ? expense.dec : -expense.dec, specifier: "%.02f")" : "").frame(height: 20)
//            }.frame(maxWidth: .infinity)
//        }
//}

