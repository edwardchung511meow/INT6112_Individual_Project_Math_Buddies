//
//  DailyChallengePracticeView.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import SwiftUI

struct DailyChallengePracticeView: View {
    @Environment(\.dismiss) var dismiss
    var dismissSheet: () -> Void = { }

    @AppStorage("selectedGrade") private var selectedGrade: Int = 3

    @State private var questions: [Question] = []

    @State private var currentIndex: Int = 0
    @State private var selectedChoice: String? = nil
    @State private var showFeedback: Bool = false
    @State private var goToResult: Bool = false

    @State private var correct: Int = 0
    @State private var wrong: Int = 0

    // MARK: Progress
    private var progress: CGFloat {
        let total = max(questions.count, 1)
        let current = min(currentIndex, total)   // 題目在畫面上時就是已完成
        return CGFloat(current) / CGFloat(total)
    }

    var body: some View {
        ZStack {
            // 背景
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {

                // MARK: Progress Bar
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(height: 12)

                    Capsule()
                        .fill(Color.white)
                        .frame(
                            width: (UIScreen.main.bounds.width * 0.85) * min(progress, 1),
                            height: 8
                        )
                }
                .padding(.vertical, 24)
                .padding(.horizontal)
                
//                Text("\(progress)")

                // MARK: 題目區
                if currentIndex < questions.count {
                    let question = questions[currentIndex]

                    Text(question.question)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    // 選項
                    VStack(spacing: 24) {
                        ForEach(question.choices, id: \.self) { choice in
                            Button {
                                selectedChoice = choice
                                showFeedback = true

                                // 記錄答題
                                if choice == question.correct {
                                    correct += 1
                                } else {
                                    wrong += 1
                                }

                                // 延遲切換下一題
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                                    selectedChoice = nil
                                    showFeedback = false
                                    currentIndex += 1
                                }

                            } label: {
                                HStack {
                                    Text(choice)
                                        .font(.body.weight(.semibold))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(buttonColor(choice: choice, correctAns: question.correct))
                                        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 3)
                                )
                            }
                            .disabled(selectedChoice != nil) // 防止連點
                        }
                    }
                }

                Spacer()

            }
            .padding()
        }
        .onAppear {
            loadDailyQuestions()
        }
        .onChange(of: progress, { oldValue, newValue in
            if progress >= 1 {
                goToResult = true
            }
        })
        .navigationDestination(isPresented: $goToResult) {
            ResultView(dismissSheet: dismissSheet, correct: correct, wrong: wrong, total: questions.count)
        }
    }

    // MARK: - 顏色判定
    func buttonColor(choice: String, correctAns: String) -> Color {
        guard let selected = selectedChoice else { return .white }

        if selected == choice {
            return choice == correctAns ? Color.green.opacity(0.3) : Color.red.opacity(0.3)
        }
        return .white
    }

    // MARK: - 從 selectedGrade 中抽 5 題（topic 混合）
    func loadDailyQuestions() {
        // 直接呼叫 DataLoader 的 loadQuestions() 取得題庫
        let all = DataLoader.shared.loadQuestions()

        // 過濾年級題目
        let gradeQuestions = all.filter { $0.grade == selectedGrade }

        // 隨機抽 5 題
        questions = Array(gradeQuestions.shuffled().prefix(5))
    }
}
#Preview {
    DailyChallengePracticeView()
}
