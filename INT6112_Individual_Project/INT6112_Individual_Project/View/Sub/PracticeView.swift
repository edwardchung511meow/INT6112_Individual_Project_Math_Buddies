//
//  PracticeView.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import SwiftUI

struct PracticeView: View {
    @Environment(\.dismiss) private var dismiss
    var topic: String? = nil

    @AppStorage("selectedGrade") private var selectedGrade: Int = 3
    @State private var selectedDifficulty: String = "all"
    @StateObject private var practiceVM = PracticeViewModel()
    @State private var selectedChoice: String? = nil
    @State private var showFeedback: Bool = false
    @State private var goToResult: Bool = false
    @State private var correct: Int = 0
    @State private var wrong: Int = 0

    private var progress: CGFloat {
        let total = max(practiceVM.filteredQuestions.count, 1)
        let current = min(practiceVM.currentIndex + 1, total)
        return CGFloat(current) / CGFloat(total)
    }

    var body: some View {
        ZStack {
            
            // Background to match overall app style
            LinearGradient(
                colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Practice")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: - Progress Bar
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(height: 10)

                    Capsule()
                        .fill(Color.white)
                        .frame(
                            width: max(10, progress * UIScreen.main.bounds.width),
                            height: 10
                        )
                }
                .padding(.bottom, 4)

                // MARK: - Question Card & Choices
                if let question = practiceVM.currentQuestion {

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Question \(practiceVM.currentIndex + 1)/\(max(practiceVM.filteredQuestions.count, 1))")
                            .font(.headline)
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 24) {
                            // Question text
                            Text(question.question)
                                .font(.title2.weight(.bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, 4)

                            // Choice buttons
                            VStack(spacing: 24) {
                                ForEach(question.choices, id: \.self) { choice in
                                    Button {
                                        selectedChoice = choice
                                        showFeedback = true

                                        if choice == question.correct {
                                            correct += 1
                                        } else {
                                            wrong += 1
                                        }

                                        // Delay to show feedback before moving to next question
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            practiceVM.submitAnswer(choice)
                                            selectedChoice = nil
                                            showFeedback = false
                                        }
                                    } label: {
                                        HStack {
                                            Text(choice)
                                                .font(.body.weight(.medium))
                                                .foregroundColor(.black)
                                            
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(
                                                    selectedChoice == choice
                                                    ? (choice == question.correct ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                                                    : Color.white
                                                )
                                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                        )
                                    }
                                }
                            }
                            
                            
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                        )
                    }

                }

                Spacer()
            }
            .padding()
            .onAppear {
                practiceVM.loadQuestions(grade: selectedGrade, topic: topic, difficulty: selectedDifficulty)
            }
            .onChange(of: selectedGrade) { _, newGrade in
                practiceVM.loadQuestions(grade: newGrade, topic: topic, difficulty: selectedDifficulty)
            }
            .onChange(of: practiceVM.currentIndex) { _, newValue in
                let total = practiceVM.filteredQuestions.count
                
                if progress >= 1 || newValue >= total {
                    goToResult = true
                }
            }
            .navigationDestination(isPresented: $goToResult) {
                ResultView(
                    dismissSheet: {
                        goToResult = false
                        
                        // Pop back to HomeView
                        dismiss()
                        
                        DispatchQueue.main.async {
                            dismiss()
                        }
                    },
                    correct: correct,
                    wrong: wrong,
                    total: practiceVM.filteredQuestions.count
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        PracticeView()
    }
}
