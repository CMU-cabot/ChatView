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
                    model.startChat()
                }
        }
    }
}
