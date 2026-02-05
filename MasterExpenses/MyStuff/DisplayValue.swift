//
//  DisplayValue.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-02-01.
//

import Foundation
func displayValue(_ value: Double, showSign: Bool = true) -> String {
    value != 0 ? String(format: "%.2f", showSign ? value : -value) : ""
}
