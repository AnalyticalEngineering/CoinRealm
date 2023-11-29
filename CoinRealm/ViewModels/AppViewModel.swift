//
//  AppViewModel.swift
//  CoinRealm
//
//  Created by J. DeWeese on 11/28/23.
//

import Foundation
import RealmSwift
import SwiftUI

final class AppViewModel: ObservableObject {
    
    @AppStorage("playFeedbackHaptic") var selectedFeedbackHaptic: Bool = true
    @AppStorage("hasRunBefore") var hasRunBefore: Bool = false
    @AppStorage("currencySymbol") var currencySymbol: String = "USD"
    @AppStorage("roundingNumbers") var roundingNumbers: Bool = false
    
    init() {
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
    }
}

