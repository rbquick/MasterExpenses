//
//  ContentView.swift
//  MasterExpense
//
//  Created by Brian Quick on 2026-01-24.
//

import SwiftUI
internal import UniformTypeIdentifiers

enum Mode: String, CaseIterable, Identifiable {
    case expenses = "Expenses"
    case income = "Income"
    case incomeAll = "Income All"
    case expensesAll = "Expenses All"
    var id: String { self.rawValue }
}

struct MasterView: View {
    @EnvironmentObject var expense: ExpenseModel
    @EnvironmentObject var head: HeadingModel
    @EnvironmentObject var mySearch: mySearchModel
    @Environment(\.selectedTab) var selectedTab
    @State private var selectedMode: Mode = .expenses
    @State var selectedYear1: Int = 2024
    @State var selectedYear2: Int = 2025
    @State var showmonths: Bool = false
    var body: some View {
        VStack {
            HStack {
                if !mySearch.searchIsShowing {
                    mySearchView()
                }
                    Text("Months")
                Toggle(
                    "Months",
                    isOn: Binding(
                        get: { showmonths },
                        set: { newValue in
                            showmonths = newValue
                        }
                    )
                )
                .labelsHidden()
                .toggleStyle(.switch)
                .frame(minWidth: 0, alignment: .leading)
                Text("Type")
                Picker("Mode", selection: $selectedMode) {
                    ForEach(Mode.allCases, id: \.self) { mode in
                        Text(mode.rawValue)
                    }
                }
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
//                .padding(.vertical, 4)
                Text("Select Years")
                HStack {
                    
                Picker("Year", selection: $selectedYear1) {
                    ForEach(expense.getYears(), id: \.self) { year in
                        Text("\(year)")
                    }
                }
                Picker("Year", selection: $selectedYear2) {
                    ForEach(expense.getYears(), id: \.self) { year in
                        Text("\(year)")
                    }
                }
                }
                .frame(width: 200, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
            }
            .padding()
            let myfiltered: [Expense] = mySearch.searchText.isEmpty ? expense.expenses : expense.expenses.filter { $0.name.localizedCaseInsensitiveContains(mySearch.searchText) }
            let filtered: [Expense] = {
                switch selectedMode {
                case .incomeAll:
                    return myfiltered.selected(from: head.headings.withoutExpense, years: [selectedYear1, selectedYear2])
                case .expensesAll:
                    return myfiltered.selected(from: head.headings.withExpense, years: [selectedYear1, selectedYear2])
                case .expenses:
                    return myfiltered.selected(from: head.headings.withExpenseAndTracking, years: [selectedYear1, selectedYear2])
                case .income:
                    return myfiltered.selected(from: head.headings.withoutExpenseWithTracking, years: [selectedYear1, selectedYear2])
                }
            }()
            let grouped = Dictionary(grouping: filtered, by: { $0.name })
            List {
                ForEach(grouped.keys.sorted(), id: \.self) { name in
                    let expensesForName = grouped[name] ?? []
                    let totals = expensesForName.map { $0.total }
                    let diff: Double = totals.count >= 2 ? (totals[1] - totals[0]) : 0
                    Section(header:
                                HStack {
                        Text(name).bold()
                        Spacer()
                        HeadingTogglesView(name: name)
                        
                        HStack {
                            
                            if totals.count >= 2 {
                                Text("Difference: $\(diff, specifier: "%.2f")").foregroundColor(.accentColor)
                            } else {
                                Text("Only one year").foregroundColor(.secondary)
                            }
                        }
                        .frame(minWidth: 250, alignment: .trailing)
                    }
                    ) {
                        ForEach(expensesForName.sorted(by: { $0.year < $1.year })) { expense in
                            HStack {
                                Text(expense.year.description)
                                if showmonths {
                                    
                                HStack {
                                    VStack(alignment: .trailing) {
                                        Text("Jan")
                                        Text("\(expense.jan, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Feb")
                                        Text("\(expense.feb, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Mar")
                                        Text("\(expense.mar, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Apr")
                                        Text("\(expense.apr, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("May")
                                        Text("\(expense.may, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Jun")
                                        Text("\(expense.jun, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Jul")
                                        Text("\(expense.jul, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Aug")
                                        Text("\(expense.aug, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Sep")
                                        Text("\(expense.sep, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Oct")
                                        Text("\(expense.oct, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Nov")
                                        Text("\(expense.nov, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                    VStack(alignment: .trailing) {
                                        Text("Dec")
                                        Text("\(expense.dec, specifier: "%.02f")")
                                    }.frame(maxWidth: .infinity)
                                }
                                }
                                Spacer()
                                Text("$\(expense.total, specifier: "%.2f")")
                                Text("$\(expense.average, specifier: "%.2f")")
                            }
                        }
                    }
                }
            }
        }
    }
    

}

#Preview {
    MasterView()
        .environmentObject(ExpenseModel())
        .environmentObject(HeadingModel())
        .environmentObject(mySearchModel())
}

