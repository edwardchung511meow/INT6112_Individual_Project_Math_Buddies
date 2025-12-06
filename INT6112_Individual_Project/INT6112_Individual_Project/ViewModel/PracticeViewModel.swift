//
//  PracticeViewModel.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import Foundation
internal import Combine

@MainActor
class PracticeViewModel: ObservableObject {
    
    @Published var allQuestions: [Question] = []
    @Published var filteredQuestions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var score: Int = 0
    @Published var isCompleted: Bool = false
    
    private let dataLoader = DataLoader()
    
    // Current question
    var currentQuestion: Question? {
        guard currentIndex < filteredQuestions.count else { return nil }
        return filteredQuestions[currentIndex]
    }
    
    // MARK: - Load Questions
    func loadQuestions(grade: Int? = nil, topic: String? = nil, difficulty: String? = nil) {
        allQuestions = dataLoader.loadQuestions()
        
        filteredQuestions = allQuestions.filter { q in
            let matchesGrade = (grade == nil || q.grade == grade)

            let matchesTopic = (topic == nil ||
                                q.topic.lowercased() == topic!.lowercased())

            let matchesDifficulty: Bool
            if difficulty == nil || difficulty?.lowercased() == "all" {
                matchesDifficulty = true
            } else {
                matchesDifficulty = q.difficulty.lowercased() == difficulty!.lowercased()
            }

            return matchesGrade && matchesTopic && matchesDifficulty
        }
        
        // fallback if filter returns empty
        if filteredQuestions.isEmpty {
            filteredQuestions = allQuestions.filter { q in
                grade == nil || q.grade == grade
            }
        }
        
        // Randomize order
        filteredQuestions.shuffle()
        
        currentIndex = 0
        score = 0
        isCompleted = false
    }
    
    // MARK: - Handle Answer
    func submitAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        
        if answer == question.correct {
            score += 1
        }
        
        goToNextQuestion()
    }
    
    // MARK: - Next Question
    func goToNextQuestion() {
        if currentIndex < filteredQuestions.count - 1 {
            currentIndex += 1
        } else {
            isCompleted = true
        }
    }
    
    // MARK: - Reset
    func reset() {
        currentIndex = 0
        score = 0
        isCompleted = false
    }
}
