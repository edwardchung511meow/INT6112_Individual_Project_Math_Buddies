//
//  AIChatViewModel.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import Foundation
internal import Combine

@MainActor
class AIChatViewModel: ObservableObject {

    @Published var messages: [Message] = [
        Message(
            text: "Hi! I'm your AI Math Coach. Ask me about any question!",
            isUser: false,
            timestamp: Date(),
            messageType: .system,
            isTyping: false
        )
    ]

    private let dataLoader = DataLoader()
    private var solutions: [Solution] = []

    init() {
        loadSolutions()
    }

    // MARK: - Load Solution Data
    private func loadSolutions() {
        solutions = dataLoader.loadSolutions()
    }

    // MARK: - User Sends Message
    func sendUserMessage(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let userMsg = Message(
            text: text,
            isUser: true,
            timestamp: Date(),
            messageType: .text,
            isTyping: false
        )
        messages.append(userMsg)
        simulateAIReply(to: text)
    }

    // MARK: - Simulated AI Reply (for demo purposes)
    private func simulateAIReply(to userText: String) {
        // Start typing indicator
        showTypingIndicator()

        Task {
            try? await Task.sleep(nanoseconds: 900_000_000) // simulate thinking delay

            // Simple demo responses
            let reply: String
            if userText.lowercased().contains("hello") || userText.lowercased().contains("hi") {
                reply = "Hello! How can I help you with math today?"
            } else if userText.lowercased().contains("help") {
                reply = "Sure! Tell me which part you want help with—fractions, geometry, multiplication, or anything else!"
            } else if userText.lowercased().contains("3 + 4") {
                // Trigger step-by-step demo
                Task {
                    let demoSteps = [
                        "Step 1: Identify the problem. Suppose we want to solve 3 + 4.",
                        "Step 2: Combine the numbers. 3 plus 4 equals 7.",
                        "Step 3: Therefore, the final answer is **7**."
                    ]

                    for step in demoSteps {
                        showTypingIndicator()
                        try? await Task.sleep(nanoseconds: 700_000_000)
                        replaceTypingWith(step, type: .step)
                    }
                }
                return
            } else {
                reply = "That's a great question! Let me think... Could you tell me a bit more about what you're trying to solve?"
            }

            replaceTypingWith(reply, type: .text)
        }
    }

    // MARK: - AI Typing Indicator
    private func showTypingIndicator() {
        let typingMsg = Message(
            text: "",
            isUser: false,
            timestamp: Date(),
            messageType: .system,
            isTyping: true
        )
        messages.append(typingMsg)
    }

    private func replaceTypingWith(_ text: String, type: Message.MessageType) {
        if let index = messages.lastIndex(where: { $0.isTyping }) {
            messages.remove(at: index)
        }
        messages.append(
            Message(
                text: text,
                isUser: false,
                timestamp: Date(),
                messageType: type,
                isTyping: false
            )
        )
    }

    // MARK: - Explain Question (AI Step-by-Step)
    func explainQuestion(questionID: Int) {
        guard let solution = solutions.first(where: { $0.id == questionID }) else {
            messages.append(
                Message(
                    text: "Sorry, I don't have a solution for this question yet.",
                    isUser: false,
                    timestamp: Date(),
                    messageType: .system,
                    isTyping: false
                )
            )
            return
        }

        Task {
            for step in solution.steps {
                showTypingIndicator()
                try? await Task.sleep(nanoseconds: 700_000_000) // delay for typing
                replaceTypingWith(step, type: .step)
            }
        }
    }

    // MARK: - Clear Chat
    func resetChat() {
        messages = [
            Message(
                text: "Hi! I'm your AI Math Coach. Ask me about any question!",
                isUser: false,
                timestamp: Date(),
                messageType: .system,
                isTyping: false
            )
        ]
    }
}
