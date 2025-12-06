//
//  HomeView.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//


import SwiftUI
import Foundation

struct MathTopic: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
    let colors: [Color]
}

struct HomeView: View {
    
    @State private var showingDialyChallenge: Bool = false
    @AppStorage("selectedGrade") private var selectedGrade: Int = 3

    // 各年級對應的數學主題
    private static let topicsByGrade: [Int: [MathTopic]] = [
        1: [
            MathTopic(
                title: "Counting & Numbers",
                subtitle: "Read, write and compare numbers",
                systemImage: "123.rectangle.fill",
                colors: [Color.teal, Color.teal.opacity(0.7)]
            ),
            MathTopic(
                title: "Basic Addition",
                subtitle: "Add within 20 using pictures and number lines",
                systemImage: "plus.rectangle.fill",
                colors: [Color.green, Color.green.opacity(0.7)]
            ),
            MathTopic(
                title: "Shapes & Patterns",
                subtitle: "Recognise basic 2D shapes and simple patterns",
                systemImage: "square.on.circle.fill",
                colors: [Color.purple, Color.purple.opacity(0.7)]
            )
        ],
        2: [
            MathTopic(
                title: "Add & Subtract within 100",
                subtitle: "Use mental strategies and column methods",
                systemImage: "minus.plus.batteryblock.fill",
                colors: [Color.blue, Color.blue.opacity(0.7)]
            ),
            MathTopic(
                title: "Time & Money",
                subtitle: "Read clocks and count coins",
                systemImage: "clock.badge.exclamationmark.fill",
                colors: [Color.orange, Color.orange.opacity(0.7)]
            ),
            MathTopic(
                title: "Length & Measurement",
                subtitle: "Compare and measure using cm and meter",
                systemImage: "ruler.fill",
                colors: [Color.indigo, Color.indigo.opacity(0.7)]
            )
        ],
        3: [
            MathTopic(
                title: "Multiplication Basics",
                subtitle: "Learn times tables and equal groups",
                systemImage: "xmark.circle.fill",
                colors: [Color.pink, Color.pink.opacity(0.7)]
            ),
            MathTopic(
                title: "Division Intro",
                subtitle: "Share and group objects fairly",
                systemImage: "divide.circle.fill",
                colors: [Color.cyan, Color.cyan.opacity(0.7)]
            ),
            MathTopic(
                title: "Fractions Starter",
                subtitle: "Halves, thirds and quarters of shapes",
                systemImage: "circle.lefthalf.fill",
                colors: [Color.mint, Color.mint.opacity(0.7)]
            )
        ],
        4: [
            MathTopic(
                title: "Multi-digit Multiplication",
                subtitle: "Multiply 2- and 3-digit numbers",
                systemImage: "x.squareroot",
                colors: [Color.blue, Color.blue.opacity(0.7)]
            ),
            MathTopic(
                title: "Fractions & Decimals",
                subtitle: "Compare and convert simple fractions",
                systemImage: "percent",
                colors: [Color.purple, Color.purple.opacity(0.7)]
            ),
            MathTopic(
                title: "Area & Perimeter",
                subtitle: "Measure spaces and boundaries",
                systemImage: "square.dashed",
                colors: [Color.orange, Color.orange.opacity(0.7)]
            )
        ],
        5: [
            MathTopic(
                title: "Advanced Fractions",
                subtitle: "Add, subtract and compare fractions",
                systemImage: "circle.grid.2x1.fill",
                colors: [Color.indigo, Color.indigo.opacity(0.7)]
            ),
            MathTopic(
                title: "Decimals & Percentages",
                subtitle: "Relate fractions, decimals and percent",
                systemImage: "number",
                colors: [Color.green, Color.green.opacity(0.7)]
            ),
            MathTopic(
                title: "Volume & Geometry",
                subtitle: "Prisms, nets and 3D shapes",
                systemImage: "cube.transparent",
                colors: [Color.teal, Color.teal.opacity(0.7)]
            )
        ],
        6: [
            MathTopic(
                title: "Ratio & Proportion",
                subtitle: "Scale recipes and compare quantities",
                systemImage: "divide",
                colors: [Color.orange, Color.orange.opacity(0.7)]
            ),
            MathTopic(
                title: "Pre-algebra",
                subtitle: "Use unknowns and simple equations",
                systemImage: "function",
                colors: [Color.pink, Color.pink.opacity(0.7)]
            ),
            MathTopic(
                title: "Data & Graphs",
                subtitle: "Read bar charts and line graphs",
                systemImage: "chart.line.uptrend.xyaxis",
                colors: [Color.blue, Color.blue.opacity(0.7)]
            )
        ]
    ]

    var body: some View {
        ZStack {
            // MARK: - Background Gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Large Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Math Buddies")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)


                    // MARK: - Daily Challenge Card
                    HomeFeatureCard(
                        title: "Daily Challenge",
                        subtitle: "5 quick questions to stay sharp!",
                        systemImage: "flame.fill",
                        colors: [Color.orange, Color.orange.opacity(0.7)]
                    )
                    .onTapGesture {
                        showingDialyChallenge = true
                    }
                    .sheet(isPresented: $showingDialyChallenge) {
                        NavigationStack {
                            DailyChallengeView(dismissSheet: {
                                showingDialyChallenge = false
                            })
                        }
                    }

                    // MARK: - Main Activity List (Grade & Topics)
                    VStack(alignment: .leading, spacing: 24) {

                        // Grade Selector
                        HStack {
                            Text("Your Grade")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            Spacer()
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(1...6, id: \.self) { grade in
                                    let isSelected = grade == selectedGrade
                                    Text("Grade \(grade)")
                                        .font(.subheadline.bold())
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            isSelected ? Color.white : Color.white.opacity(0.25)
                                        )
                                        .foregroundColor(isSelected ? .blue : .white)
                                        .cornerRadius(16)
                                        .onTapGesture {
                                            selectedGrade = grade
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal, -16)

                        // Grade-specific topics
                        HStack {
                            Text("Topics for Grade \(selectedGrade)")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 4)

                        ForEach(HomeView.topicsByGrade[selectedGrade] ?? []) { topic in
                            NavigationLink {
                                PracticeView(topic: topic.title)
                            } label: {
                                HomeFeatureCard(
                                    title: topic.title,
                                    subtitle: topic.subtitle,
                                    systemImage: topic.systemImage,
                                    colors: topic.colors
                                )
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Reusable Feature Card
struct HomeFeatureCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let colors: [Color]

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Image(systemName: systemImage)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
