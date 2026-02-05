//
//  MyDefailts.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-02-03.
//

import SwiftUI
class MyDefaults {
    static let shared = MyDefaults()
    var showViewNames: Bool = false
    // other properties and methods
    
    var selectedYear1: Int {
        get { let value = UserDefaults.standard.object(forKey: "selectedYear1") as? Int; return value ?? 2024 }
        set { UserDefaults.standard.set(newValue, forKey: "selectedYear1")}
    }
    var selectedYear2: Int {
        get { let value = UserDefaults.standard.object(forKey: "selectedYear2") as? Int; return value ?? 2024 }
        set { UserDefaults.standard.set(newValue, forKey: "selectedYear2")}
    }
}

