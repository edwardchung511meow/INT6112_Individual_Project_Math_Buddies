//
//  AIChatView.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import SwiftUI

struct AIChatView: View {
    @StateObject private var aiChatVM = AIChatViewModel()
    @State private var inputText: String = ""
    var questionID: Int? = nil
    
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
                    Text("AI Coach")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: - Chat Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(aiChatVM.messages) { msg in
                                HStack {
                                    if msg.isUser {
                                        Spacer()
                                        
                                        Text(msg.text)
                                            .padding(12)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(16)
                                            .frame(maxWidth: 260, alignment: .trailing)
                                    } else {
                                        Text(msg.text.isEmpty && msg.isTyping ? "•••" : msg.text)
                                            .padding(12)
                                            .background(Color(.systemGray6))
                                            .foregroundColor(.primary)
                                            .cornerRadius(16)
                                            .frame(maxWidth: 260, alignment: .leading)
                                        
                                        Spacer()
                                    }
                                }
                                .id(msg.id)
                            }
                        }
                    }
                    .onChange(of: aiChatVM.messages.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo(aiChatVM.messages.last?.id)
                        }
                    }
                }

                // MARK: - Input Bar
                HStack(spacing: 12) {
                    TextField("Ask me anything…", text: $inputText)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(16)

                    Button {
                        aiChatVM.sendUserMessage(inputText)
                        inputText = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
        }
        .onAppear {
            if let id = questionID {
                aiChatVM.resetChat()
                aiChatVM.explainQuestion(questionID: id)
            }
        }
    }
}

#Preview {
    AIChatView()
}
