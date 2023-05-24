//
//  TransactionModel.swift
//  ExpenseTracker
//
//  Created by Mykyta Babanin on 22.05.2023.
//

import Foundation
import SwiftUIFontIcon

struct Transaction: Identifiable, Decodable, Hashable {
    var id: String
    let time: Int
    let description: String
    let amount: Int
    
    var dateParsed: Date {
        time.dateParse()
    }
    
    var icon: FontAwesomeCode {
        return .question
    }
    
    var month: String {
        dateParsed.formatted(.dateTime.year().month(.wide))
    }
}
                                               
                                               
