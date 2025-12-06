//
//  DashboardView.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import SwiftUI

struct DashboardView: View {
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
                // MARK: - Large Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dashboard")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: - Daily Summary Card
                VStack(alignment: .leading, spacing: 16) {

                    HStack {
                        Text("Today's Summary")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "sun.max.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Questions Solved")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("12")
                                .font(.title3.bold())
                        }
                        Spacer()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Accuracy")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("83%")
                                .font(.title3.bold())
                        }
                        Spacer()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Time Spent")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("18 min")
                                .font(.title3.bold())
                        }
                    }

                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(22)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)

                // MARK: - Progress Rings
                VStack(alignment: .leading, spacing: 14) {
                    Text("This Week's Progress")
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack(spacing: 16) {

                        ProgressRing(value: 65, title: "Mastery")
                        ProgressRing(value: 42, title: "Speed")
                        ProgressRing(value: 78, title: "Consistency")

                    }
                }

                // MARK: - Quick Stats Section (Line Chart)
                VStack(alignment: .leading, spacing: 14) {
                    Text("Quick Stats")
                        .font(.headline)
                        .foregroundColor(.white)

                    // Background Card
                    VStack(alignment: .leading, spacing: 20) {

                        // Title
                        Text("Last 7 Days Performance")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        // Line Chart
                        MultiLineChartView(
                            series: [
                                .init(name: "Correct", color: .green, values: [12, 18, 15, 22, 17, 25, 21]),
                                .init(name: "Wrong", color: .red, values: [4, 6, 5, 7, 6, 5, 4]),
                                .init(name: "Speed", color: .orange, values: [60, 62, 65, 70, 72, 75, 78])
                            ]
                        )
                        .frame(height: 180)
                        
                        // Inline Summary
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Avg Accuracy")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("82%")
                                    .font(.headline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Total Questions")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("127")
                                    .font(.headline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Mastered")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("15")
                                    .font(.headline)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 2)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Progress Ring Component
struct ProgressRing: View {
    let value: Double
    let title: String

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.25), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: value / 100)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                Text("\(Int(value))%")
                    .font(.headline.bold())
                    .foregroundColor(.white)
            }
            .frame(width: 80, height: 80)

            Text(title)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Dashboard Stat Card Component
struct DashboardStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(value)
                    .font(.title3.bold())
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    DashboardView()
}

// MARK: - Multi-Line Chart with Tooltip
struct MultiLineChartView: View {
    struct Series: Identifiable {
        let id = UUID()
        let name: String
        let color: Color
        let values: [CGFloat]
    }

    let series: [Series]
    @State private var selectedIndex: Int? = nil

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height

            let maxCount = series.first?.values.count ?? 0
            let allValues = series.flatMap { $0.values }
            let maxValue = (allValues.max() ?? 1)

            let allPoints: [[CGPoint]] = series.map { s in
                s.values.enumerated().map { index, value in
                    CGPoint(
                        x: maxCount > 1 ? width * CGFloat(index) / CGFloat(maxCount - 1) : width / 2,
                        y: height - (value / maxValue * height)
                    )
                }
            }

            ZStack {
                // Filled areas per series (optional: only first, but here we don't fill)

                // Lines and points
                ForEach(series.indices, id: \ .self) { sIndex in
                    let pts = allPoints[sIndex]
                    let s = series[sIndex]

                    Path { path in
                        guard let first = pts.first else { return }
                        path.move(to: first)
                        pts.dropFirst().forEach { path.addLine(to: $0) }
                    }
                    .stroke(s.color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))

                    ForEach(pts, id: \.self) { point in
                        Circle()
                            .fill(s.color)
                            .frame(width: 8, height: 8)
                            .position(point)
                    }
                }

                // Tooltip + vertical guideline
                if let index = selectedIndex,
                   let maxCount = series.first?.values.count,
                   maxCount > 0,
                   index >= 0, index < maxCount {

                    let xPos = maxCount > 1 ? width * CGFloat(index) / CGFloat(maxCount - 1) : width / 2

                    // Vertical line
                    Path { path in
                        path.move(to: CGPoint(x: xPos, y: 0))
                        path.addLine(to: CGPoint(x: xPos, y: height))
                    }
                    .stroke(Color.white.opacity(0.6), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    // Tooltip data
                    let tooltipData: [(String, CGFloat, Color)] = series.map { s in
                        let value = index < s.values.count ? s.values[index] : 0
                        return (s.name, value, s.color)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Day \(index + 1)")
                            .font(.caption.bold())
                        ForEach(Array(tooltipData.enumerated()), id: \.offset) { _, item in
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(item.2)
                                    .frame(width: 6, height: 6)
                                Text("\(item.0): \(Int(item.1))")
                                    .font(.caption2)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .position(x: min(max(xPos, 80), width - 80), y: 30)
                }

                // Drag gesture overlay
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let x = value.location.x
                                guard width > 0, let maxCount = series.first?.values.count, maxCount > 1 else { return }
                                let ratio = max(0, min(1, x / width))
                                let idx = Int(round(ratio * CGFloat(maxCount - 1)))
                                selectedIndex = idx
                            }
                            .onEnded { _ in }
                    )
            }
        }
    }
}

// MARK: - Line Chart Component
struct LineChartView: View {
    let dataPoints: [CGFloat]
    let lineColor: Color
    let fillGradient: LinearGradient

    var body: some View {
        GeometryReader { geo in
            let maxValue = (dataPoints.max() ?? 1)
            let width = geo.size.width
            let height = geo.size.height

            // Convert data to points on graph
            let points = dataPoints.enumerated().map { index, value in
                CGPoint(
                    x: width * CGFloat(index) / CGFloat(dataPoints.count - 1),
                    y: height - (value / maxValue * height)
                )
            }

            ZStack {
                // Fill Area
                Path { path in
                    path.move(to: points.first ?? .zero)
                    points.forEach { path.addLine(to: $0) }
                    path.addLine(to: CGPoint(x: points.last?.x ?? 0, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                    path.closeSubpath()
                }
                .fill(fillGradient)

                // Line Stroke
                Path { path in
                    path.move(to: points.first ?? .zero)
                    points.forEach { path.addLine(to: $0) }
                }
                .stroke(lineColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))

                // Dots
                ForEach(points, id: \.self) { point in
                    Circle()
                        .fill(lineColor)
                        .frame(width: 8, height: 8)
                        .position(x: point.x, y: point.y)
                }
            }
        }
    }
}
