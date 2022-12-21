//
//  ShowSheetView.swift
//  MultiTable
//
//  Created by Andrey Matviets on 18.12.2022.
//

import SwiftUI

struct ShowSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var arrayOfQuestions: dataToShare
    
    var body: some View {
        NavigationView {
 
            List {
                ForEach(arrayOfQuestions.items) { item in
                    Text ("\(item.textToShow) = \(item.correctAnswer)")
                }
            }
            .toolbar {
                ToolbarItemGroup{
                    Button ("Dismiss") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Table of wright answers")
        }
    }
}


struct ShowSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ShowSheetView(arrayOfQuestions: dataToShare())
    }
}
