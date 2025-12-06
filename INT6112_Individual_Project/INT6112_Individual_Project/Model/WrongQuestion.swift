//
//  WrongQuestion.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import Foundation

struct WrongQuestion: Identifiable {
    let id: Int
    let question: String
    let userAnswer: String
    let correctAnswer: String
    let tag: String
    let difficulty: String
    var mastered: Bool
}
