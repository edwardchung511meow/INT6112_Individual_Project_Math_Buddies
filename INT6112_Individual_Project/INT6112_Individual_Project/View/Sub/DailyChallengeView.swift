//
//  DailyChallengeView.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import SwiftUI

struct DailyChallengeView: View {
    @Environment(\.dismiss) var dismiss
    var dismissSheet:  () -> Void = { }

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

                // MARK: - Title
                HStack {
                    Text("Daily Challenge")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.top, -24)

                // MARK: - White Card
                VStack(spacing: 24) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.orange)

                    Text("Today's Goal")
                        .font(.title2.bold())

                    Text("Answer 5 math questions to earn your daily badge.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 24)

                }
                .padding()
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)

                Spacer()

                // MARK: - Start Button
                NavigationLink {
                    DailyChallengePracticeView(dismissSheet: dismissSheet)
                } label: {
                    Text("Start Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(16)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }

            }
        }
    }
}

#Preview {
    NavigationStack {
        DailyChallengeView()
    }
}
