//
//  Question.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import Foundation

struct Question: Identifiable, Codable {
    let id: Int
    let grade: Int
    let topic: String
    let difficulty: String
    let question: String
    let choices: [String]
    let correct: String
    let hint: String
}
