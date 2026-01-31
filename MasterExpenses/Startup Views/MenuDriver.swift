//
//  MenuDriver.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-01-27.
//

import SwiftUI

struct SelectedTabKey: EnvironmentKey {
    static let defaultValue: Binding<Int>? = nil
}

extension EnvironmentValues {
    var selectedTab: Binding<Int>? {
        get { self[SelectedTabKey.self] }
        set { self[SelectedTabKey.self] = newValue }
    }
}

struct MenuDriver: View {
    @StateObject var expense: ExpenseModel = ExpenseModel()
    @StateObject var heading: HeadingModel = HeadingModel()
    @StateObject var mysearch: mySearchModel = mySearchModel()
    @State private var selectedTab:Int = 1
    var body: some View {
        
        TabView(selection: $selectedTab) {
            MasterView().tabItem {
                Text("Master")
            }.tag(1)

            HeadingsView().tabItem {
                Text("Headings")
            }.tag(2)

        }
        .environmentObject(expense)
        .environmentObject(heading)
        .environmentObject(mysearch)
        .environment(\.selectedTab, $selectedTab)
    }
}
#Preview {
    MenuDriver()
}
