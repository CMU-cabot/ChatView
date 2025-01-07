/*******************************************************************************
 * Copyright (c) 2024  Carnegie Mellon University
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *******************************************************************************/

import Combine
import SwiftUI
import ChatView

public struct ContentView: View {
    @StateObject var model: ChatViewModel

    public var body: some View {
        ChatView(messages: model.messages)
        HStack {
            Spacer()
            ChatStateButton(action: {
                model.toggleChat()
            }, state: $model.chatState)
            .frame(width: 150)
            Spacer()
        }
        .frame(height: 200)
        .onAppear() {
            model.stt = AppleSTT(state: $model.chatState, tts: SimpleTTS.shared)
            model.chat = ChatClientMock(callback: model.process)
            model.chat?.send(message: "")
        }
    }
}

#Preview("ChatView") {
    let model = ChatViewModel()
    model.messages = [
        ChatMessage(user: .User, text: "Hello1\nHello2\nHello3"),
        ChatMessage(user: .Agent, text: "Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2"),
        ChatMessage(user: .User, text: "Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 ")
    ]
    return ContentView(model: model)
}

#Preview("ChatView Dynamic") {
    let model = ChatViewModel()
    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
        model.messages.append(ChatMessage(user: .User, text: "Hello1\nHello2\nHello3"))
    }
    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
        model.messages.append(ChatMessage(user: .Agent, text: "Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2 Hello2"))
    }
    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
        model.messages.append(ChatMessage(user: .User, text: "Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 Hello3 "))
    }
    return ContentView(model: model)
}

#Preview("ChatView Streaming") {
    let model = ChatViewModel()
    let message = ChatMessage(user: .Agent, text: "")
    let long_sample: String = "This is a sample message."
    var count = 0
    Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {timer in
        let text = long_sample
        if count < text.count {
            let index = text.index(text.startIndex, offsetBy: count)
            let character = text[index]
            message.append(text: String(character))
            count += 1
        } else {
            model.chatState.chatState = .Inactive
            timer.invalidate()
        }
    }
    model.messages.append(message)
    model.chatState.chatState = .Speaking
    return ContentView(model: model)
}

#Preview("ChatView Scrolling") {
    let model = ChatViewModel()
    let agentMessage = ChatMessage(user: .Agent, text: "Hello")
    let userMessage = ChatMessage(user: .User, text: "Hello")
    func expand_loop(_ count: Int = 5) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            agentMessage.append(text: "\nHello")
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                userMessage.append(text: "\nHello")
                if count > 0 {
                    expand_loop(count - 1)
                }
            }
        }

    }
    func add_loop(_ count: Int = 5) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            model.messages.append(agentMessage)
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                model.messages.append(userMessage)
                if count > 0 {
                    add_loop(count - 1)
                } else{
                    expand_loop()
                }
            }
        }
    }
    add_loop()
    return ContentView(model: model)
}
