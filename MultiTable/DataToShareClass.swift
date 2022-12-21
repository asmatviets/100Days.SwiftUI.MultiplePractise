//
//  SwiftClass.swift
//  MultiTable
//
//  Created by Andrey Matviets on 18.12.2022.
//

import Foundation

class dataToShare: ObservableObject {
    @Published var items = [QuestionItems]()
}


/*
 class dataToShare: ObservableObject {
     @Published var items = [QuestionItems]() {
         didSet {
             let encoder = JSONEncoder()
             
             if let encoded = try? encoder.encode(items) {
                 UserDefaults.standard.set(encoded, forKey: "Items")
             }
         }
     }
     init() {
         if let savedItems = UserDefaults.standard.data(forKey: "Items") {
             if let decodedItems = try? JSONDecoder().decode([QuestionItems].self, from: savedItems) {
                 items = decodedItems
                 return
             }
         }
         items = []
     }
 }
 */
