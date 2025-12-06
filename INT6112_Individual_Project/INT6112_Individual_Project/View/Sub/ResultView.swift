//
//  ResultView.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import SwiftUI

struct ResultView: View {
    let dismissSheet: () -> Void
    
    let correct: Int
    let wrong: Int
    let total: Int
    
    private var accuracy: Int {
        guard total > 0 else { return 0 }
        return Int((Double(correct) / Double(total)) * 100)
    }
    
    var body: some View {
        ZStack {
            // MARK: - Background Gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // MARK: - Title
                HStack {
                    Text("Your Results")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }

                // MARK: - Score Card
                VStack(spacing: 16) {
                    Text("Score")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.black)

                    Text("\(correct) / \(total)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)

                    Text(accuracy >= 80 ? "Great job! 🎉" :
                         accuracy >= 50 ? "Keep practicing! 💪" :
                         "Don't give up! 🌟")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                )

                // MARK: - Summary Stats
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Label("Correct Answers", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Text("\(correct)")
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Label("Wrong Answers", systemImage: "xmark.circle.fill")
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        Text("\(wrong)")
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Label("Accuracy", systemImage: "percent")
                            .foregroundColor(.yellow)
                        
                        Spacer()
                        
                        Text("\(accuracy)%")
                            .foregroundColor(.black)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                )

                Spacer()
                
                // Back to Home
                Button {
                    // 統一交由外層決定如何回到 Home
                    dismissSheet()
                } label: {
                    Text("Back to Home")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(16)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ResultView(dismissSheet: {}, correct: 8, wrong: 2, total: 10)
}
