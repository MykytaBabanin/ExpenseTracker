//
//  PreviewData.swift
//  ExpenseTracker
//
//  Created by Mykyta Babanin on 23.05.2023.
//

import Foundation
import SwiftUI

var transactionPreviewData = Transaction(id: "dsadas", time: 12323231, description: "VARLIK ANTALYA MJET", amount: -22052)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
