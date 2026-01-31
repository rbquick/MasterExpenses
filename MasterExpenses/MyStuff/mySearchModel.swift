//
//  mySearchModel.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-01-30.
//

import SwiftUI
import Combine

class mySearchModel: ObservableObject {
    
    // search bar
    @Published var searchIsShowing = false {
        didSet {
            searchText = ""
            searching = false
        }
    }
    @Published var searchText = ""
    @Published var searching = false
}
