//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Mykyta Babanin on 22.05.2023.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var transactionListsViewModel: TransactionListViewModel
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, content: {
                        
                        //MARK: Title
                        Text("Overview")
                            .font(.title2)
                            .bold()
                        
                        //MARK: Chart
                        
                        let data = transactionListsViewModel.accumulateTransaction()
                        if !data.isEmpty {
                            let totalExpenses = data.last?.1 ?? 0
                            CardView {
                                VStack(alignment: .leading) {
                                    ChartLabel(totalExpenses.formatted(.currency(code: "EUR")), type: .title, format: "€%.02f")
                                    LineChart()
                                }
                                .background(Color.systemBackground)
                            }.data(data)
                                .chartStyle(.init(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                                .frame(height: 300)
                            .padding(.bottom)
                        }
                        //MARK: Transaction List
                        RecentTransactionList()
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .background(Color.background)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Image(systemName: "bell.badge")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.icon, .primary)
                    }
                }
            }
            .accentColor(.primary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListViewModel: TransactionListViewModel = {
       let transactionListViewModel = TransactionListViewModel()
        transactionListViewModel.transactions = transactionListPreviewData
        return transactionListViewModel
    }()
    
    
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(transactionListViewModel)
            ContentView()
                .environmentObject(transactionListViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
