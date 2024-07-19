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


import SwiftUI


public struct ChatView: View {
    private var messages: [ChatMessage]
    
    public init(messages: [ChatMessage]) {
        self.messages = messages
    }
    public var body: some View {
        ScrollView {
            ForEach(self.messages) { message in
                HStack {
                    switch message.user {
                    case .Agent:
                        Text(message.text)
                            .roundedBorderStyle()

                        Spacer()
                    case .User:
                        Spacer()
                        Text(message.text)
                            .roundedBorderStyle()
                    }
                }
            }
            .padding(32)
        }
    }
}

#Preview {
    ChatView(messages: [
        ChatMessage(user: .User, text: "Hello1"),
        ChatMessage(user: .Agent, text: "Hello2"),
        ChatMessage(user: .User, text: "Hello3")
    ])
}
