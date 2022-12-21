//
//  questionItems.swift
//  MultiTable
//
//  Created by Andrey Matviets on 18.12.2022.
//

import Foundation


struct QuestionItems: Identifiable, Codable, Equatable {
    var id = UUID()
    var textToShow: String
    var correctAnswer: String
}
