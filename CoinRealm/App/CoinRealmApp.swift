//
//  CoinRealmApp.swift
//  CoinRealm
//
//  Created by J. DeWeese on 11/28/23.
//

import SwiftUI

@main
struct CoinRealmApp: App {
    
    @ObservedObject var appVM = AppViewModel()
    @ObservedObject var categoryVM = CategoryViewModel()
    @ObservedObject var transactionVM = TransactionViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            if !appVM.hasRunBefore {
                WelcomeView()
                    .environmentObject(appVM)
                    .environmentObject(categoryVM)
                    .environmentObject(transactionVM)
                
            } else {
                HomeView()
                    .environmentObject(appVM)
                    .environmentObject(categoryVM)
                    .environmentObject(transactionVM)
            }
        }
    }
}

