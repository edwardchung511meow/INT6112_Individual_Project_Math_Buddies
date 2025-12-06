//
//  DataLoader.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import Foundation
internal import Combine

class DataLoader {
    static let shared = DataLoader()
    
    @Published var questions: [Question] = []
    
    init() {
        loadQuestions()
    }

    // MARK: - Load Questions
    func loadQuestions() -> [Question] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("❌ Failed to find questions.json")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([Question].self, from: data)
            return questions
        } catch {
            print("❌ Error decoding questions.json: \(error)")
            return []
        }
    }

    // MARK: - Load Solutions
    func loadSolutions() -> [Solution] {
        guard let url = Bundle.main.url(forResource: "solutions", withExtension: "json") else {
            print("❌ Failed to find solutions.json")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let solutions = try JSONDecoder().decode([Solution].self, from: data)
            return solutions
        } catch {
            print("❌ Error decoding solutions.json: \(error)")
            return []
        }
    }
}
