//
//  HomeView.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack {
                WrongsView()
            }
            .tabItem {
                Label("Wrongs", systemImage: "long.text.page.and.pencil.fill")
            }
            
            AIChatView()
                .tabItem {
                    Label("AI Coach", systemImage: "brain.head.profile")
                }
            
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.horizontal.page.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
