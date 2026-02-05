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
    @State private var selectedMode: Mode = .expenses
    @State var selectedYear1: Int = 2024
    @State var selectedYear2: Int = 2025
    @State var showmonths: Bool = true
    var showSign: Bool { selectedMode != .income && selectedMode !=  .incomeAll }

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
                    .onChange(of: selectedYear1) { orgValue, newValue in
                        MyDefaults.shared.selectedYear1 = newValue
                    }
                    Picker("Year", selection: $selectedYear2) {
                        ForEach(expense.getYears(), id: \.self) { year in
                            Text("\(year)")
                        }
                    }
                    .onChange(of: selectedYear2) { orgValue, newValue in
                        MyDefaults.shared.selectedYear2 = newValue
                    }
                }
                .frame(width: 200, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
            }
            .padding(.horizontal)
            .onAppear {
                selectedYear1 = MyDefaults.shared.selectedYear1
                selectedYear2 = MyDefaults.shared.selectedYear2
            }
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
            // Compute grand totals for each year from filtered expenses
             var grandTotals: [Double] {
                let year1Total = filtered.filter { $0.year == selectedYear1 && head.headingIsTracked($0.name) }.reduce(0) { $0 + $1.total }
                let year2Total = filtered.filter { $0.year == selectedYear2 && head.headingIsTracked($0.name) }.reduce(0) { $0 + $1.total }

                 return [year1Total, year2Total]
            }
            
            var monthTotals: [Expense] {
                let years = [selectedYear1, selectedYear2]
                var results: [Expense] = []
                for year in years {
                    let yearExpenses = filtered.filter { $0.year == year }
                    // Sum each month for this year
                    let jan = yearExpenses.reduce(0) { $0 + $1.jan }
                    let feb = yearExpenses.reduce(0) { $0 + $1.feb }
                    let mar = yearExpenses.reduce(0) { $0 + $1.mar }
                    let apr = yearExpenses.reduce(0) { $0 + $1.apr }
                    let may = yearExpenses.reduce(0) { $0 + $1.may }
                    let jun = yearExpenses.reduce(0) { $0 + $1.jun }
                    let jul = yearExpenses.reduce(0) { $0 + $1.jul }
                    let aug = yearExpenses.reduce(0) { $0 + $1.aug }
                    let sep = yearExpenses.reduce(0) { $0 + $1.sep }
                    let oct = yearExpenses.reduce(0) { $0 + $1.oct }
                    let nov = yearExpenses.reduce(0) { $0 + $1.nov }
                    let dec = yearExpenses.reduce(0) { $0 + $1.dec }
                    let total = yearExpenses.reduce(0) { $0 + $1.total }
                    let average = yearExpenses.isEmpty ? 0.0 : total / Double(yearExpenses.count)
                    // Use a placeholder name, e.g. "Summary" for the summary entry
                    results.append(Expense(name: "Summary", year: year, jan: jan, feb: feb, mar: mar, apr: apr, may: may, jun: jun, jul: jul, aug: aug, sep: sep, oct: oct, nov: nov, dec: dec, total: total, average: average))
                }
                return results
            }
            
//            HStack {
//                Text("Total \(String(format: "%d", selectedYear1)): $\(displayValue(grandTotals[0], showSign: showSign))")
//                Spacer()
//                Text("Total \(String(format: "%d", selectedYear2)): $\(displayValue(grandTotals[1], showSign: showSign))")
//            }
//            .font(.title2.bold())
//            .padding()
            // accumulate the expense.total by the year where selecteYear1 goes into grandtotal[0] and selectedYear2 goes into grandtotal[1] using the filtered array of Expense
            VStack {
                Text("Gand totals by month")
                ForEach(monthTotals.sorted(by: { $0.year < $1.year })) { expense in
                    HStack {
                        Text(expense.year.description)
                        if showmonths {
                            HStack {
                                masterMonthsview(expense: expense, showSign: showSign)
                            }
                        }
                    Spacer()
                        HStack {
                            Text("$\(displayValue(expense.total, showSign: showSign))")
                            Text("$\(displayValue(expense.average, showSign: showSign))")
                        }
                        .frame(width: 180, alignment: .trailing)
                        .alignmentGuide(.trailing) { d in d[.trailing] }
                    }
                }
            }
            .padding(.horizontal)
            .font(.system(size: 15))
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
                                        masterMonthsview(expense: expense, showSign: showSign)
                                    }
                                }
                            Spacer()
                                HStack {
                                    Text("$\(displayValue(expense.total, showSign: showSign))")
                                    Text("$\(displayValue(expense.average, showSign: showSign))")
                                }
                                .frame(width: 180, alignment: .trailing)
                                .alignmentGuide(.trailing) { d in d[.trailing] }
                            }
                        }
                    }
                }
            }
            
            .font(.system(size: 15))
        }
    }
}
    


#Preview {
    MasterView()
        .environmentObject(ExpenseModel())
        .environmentObject(HeadingModel())
        .environmentObject(mySearchModel())
}

