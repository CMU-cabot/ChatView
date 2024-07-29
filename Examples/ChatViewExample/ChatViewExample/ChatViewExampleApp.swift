//
//  ChatViewExampleApp.swift
//  ChatViewExample
//
//  Created by Daisuke Sato on 7/29/24.
//

import SwiftUI
import ChatView

@main
struct ChatViewExampleApp: App {
    var body: some Scene {
        WindowGroup {
            let model = ChatViewModel()
            ContentView(model: model)
                .onAppear() {
                    model.messages = [
                        ChatMessage(user: .User, text: "Hello1\nHello2\nHello3"),
                        ChatMessage(user: .Agent, text: "Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2"),
                        ChatMessage(user: .User, text: "Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 ")
                    ]
                }
        }
    }
}
