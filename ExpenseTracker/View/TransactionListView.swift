//
//  TransactionView.swift
//  ExpenseTracker
//
//  Created by Mykyta Babanin on 23.05.2023.
//

import SwiftUI

struct TransactionListView: View {
    @EnvironmentObject var transactionListViewModel: TransactionListViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(transactionListViewModel.groupTransactionByMonth()), id: \.key) { month, transactions in
                    Section {
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    } header: {
                        Text(month)
                    }
                }
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static let transactionListViewModel: TransactionListViewModel = {
       let transactionListViewModel = TransactionListViewModel()
        transactionListViewModel.transactions = transactionListPreviewData
        return transactionListViewModel
    }()
    
    static var previews: some View {
        Group {
            NavigationStack {
                TransactionListView()
                    .environmentObject(transactionListViewModel)
            }
            
            NavigationStack {
                TransactionListView()
                    .environmentObject(transactionListViewModel)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
