//
//  WrongsView.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import SwiftUI

struct WrongsView: View {
    @State private var searchText = ""
    @State private var selectedTag = "All"

    @State private var items: [WrongQuestion] = []
    
    let tags = ["All", "Multiplication", "Fractions", "Geometry"]
    
    // Load sample data (later connect to real data)
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        self._items = State(initialValue: [
            WrongQuestion(id: 1, question: "What is 7 × 8?", userAnswer: "54", correctAnswer: "56", tag: "Multiplication", difficulty: "Easy", mastered: true),
            WrongQuestion(id: 2, question: "Which fraction is larger: 2/5 or 3/7?", userAnswer: "3/7", correctAnswer: "2/5", tag: "Fractions", difficulty: "Medium", mastered: false),
            WrongQuestion(id: 3, question: "Find the perimeter of a square with side 6.", userAnswer: "20", correctAnswer: "24", tag: "Geometry", difficulty: "Hard", mastered: false)
        ])
    }
    
    private var filteredItems: [WrongQuestion] {
        items.filter { q in
            (selectedTag == "All" || q.tag == selectedTag) &&
            (searchText.isEmpty || q.question.localizedCaseInsensitiveContains(searchText))
        }
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
            
            VStack(spacing: 16) {

                // FIXED HEADER (always stays at the top)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Wrongs")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    TextField("Search questions...", text: $searchText)
                        .padding(16)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.subheadline.bold())
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(
                                        selectedTag == tag ?
                                        Color.white.opacity(0.85) :
                                        Color.white.opacity(0.35)
                                    )
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        selectedTag = tag
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, -16)
                }

                // SCROLLABLE LIST
                List {
                    ForEach(filteredItems) { item in
                        NavigationLink {
                            AIChatView(questionID: item.id)
                        } label: {
                            WrongQuestionCard(item: item)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                items.removeAll { $0.id == item.id }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                if let index = items.firstIndex(where: { $0.id == item.id }) {
                                    items[index].mastered.toggle()
                                }
                            } label: {
                                Label("Mastered", systemImage: "checkmark.circle.fill")
                            }
                            .tint(.green)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .background(Color.clear)
            }
            .padding()
        }
    }
}

struct WrongQuestionCard: View {
    let item: WrongQuestion
    var difficultyColor: Color {
        switch item.difficulty {
        case "Easy": return .green
        case "Medium": return .orange
        case "Hard": return .red
        default: return .blue
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.tag)
                    .font(.caption)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(8)
                
                Text(item.difficulty)
                    .font(.caption)
                    .foregroundStyle(difficultyColor)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(difficultyColor.opacity(0.15))
                    .cornerRadius(8)
                
                Spacer()

                if item.mastered {
                    Text("Mastered")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(8)
                }
            }
            
            Text(item.question)
                .font(.headline)
            
            Text("Your answer: \(item.userAnswer)")
                .foregroundColor(.red)
            
            Text("Correct answer: \(item.correctAnswer)")
                .foregroundColor(.green)
        }
        .padding(4)
        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .padding()
    }
}

#Preview {
    NavigationStack {
        WrongsView()
    }
}
