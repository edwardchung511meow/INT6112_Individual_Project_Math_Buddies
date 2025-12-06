//
//  Message.swift
//  INT6112_Individual_Project
//
//  Created by Edward Chung on 2/12/2025.
//

import Foundation

struct Message: Identifiable {
    enum MessageType: String, Codable {
        case text
        case step
        case system
    }

    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
    let messageType: MessageType
    let isTyping: Bool
}
