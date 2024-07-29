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
                    let welcome_text = "Hello"
                    model.messages.append(ChatMessage(user: .Agent, text: welcome_text))
                    model.stt.listen([([".*"], {(str, dur) in
                        print(str)
                        model.chatText = str
                        model.messages.append(ChatMessage(user: .User, text: str))
                        model.client.send(message: str)
                    })], selfvoice: welcome_text,
                         speakendactions:[({ str in
                    })],
                         avrdelegate: nil,
                         failure:{ (e) in
                    },
                         timeout:{
                    })
                }
        }
    }
}
