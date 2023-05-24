//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Mykyta Babanin on 23.05.2023.
//

import Foundation
import Combine
import Collections

enum TransactionDataError: Error {
    case invalidURL
    case missingData
}

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var anyCancellables = Set<AnyCancellable>()
    
    init() {
        getTransactions()
    }
    
    func getTransactions() {
        guard let url = URL(string: "https://api.monobank.ua/personal/statement/0/\(getOneMonthBeforeDate())") else {
            return
        }
        
        var request = URLRequest(url: url)
        let token = Bundle.main.infoDictionary?["api_token"] as? String
        request.setValue(token, forHTTPHeaderField: "X-Token")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw TransactionDataError.invalidURL
                }
                
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished the transaction")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] result in
                self?.transactions = result
                dump(self?.transactions)
                
            }
            .store(in: &anyCancellables)
    }
    
    func groupTransactionByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month }
        
        return groupedTransactions
    }
    
    func accumulateTransaction() -> TransactionPrefixSum {
        guard !transactions.isEmpty else { return [] }
        
        let today = "05/24/2023".dateParse()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let calendar = Calendar.current
            let dailyExpenses = transactions.filter { transaction in
                let transactionDateComponents = calendar.dateComponents([.year, .month, .day], from: transaction.dateParsed)
                let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                return transactionDateComponents == dateComponents
            }
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.amount / 10 }
            
            sum += Double(dailyTotal)
            cumulativeSum.append((date.formatted(), sum / 10))
            print(date.formatted(), "dailyTotal:", dailyTotal, "sum: ", sum)
        }
        
        return cumulativeSum
    }
    
    private func removeTrailingZero(from value: Double) -> Double {
        return value.truncatingRemainder(dividingBy: 1) == 0 ? Double(Int(value)) : value
    }
    
    private func getOneMonthBeforeDate() -> Int {
        let now = Date()
        guard let oneMonthBeforeNow = Calendar.current.date(byAdding: .month, value: -1, to: now) else { return 0 }
        let timestamp = oneMonthBeforeNow.timeIntervalSince1970
        return Int(timestamp)
    }
    
}
