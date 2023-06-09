//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Mykyta Babanin on 22.05.2023.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        @StateObject var transactionListViewModel = TransactionListViewModel()
        
        WindowGroup {
            ContentView()
                .environmentObject(transactionListViewModel)
        }
    }
}
