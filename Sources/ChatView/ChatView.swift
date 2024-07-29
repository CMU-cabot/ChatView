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
    var messages: [ChatMessage]

    public init(messages: [ChatMessage]) {
        self.messages = messages
    }

    public var body: some View {
        ScrollView {
            ForEach(self.messages) { message in
                MessageView(message: message)
            }
            .padding(16)
        }
    }
}

struct MessageView: View {
    @StateObject var message: ChatMessage
    var duration: Double = 0.2
    @State private var offset: CGFloat = 32
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 0.0

    var body: some View {
        switch message.user {
        case .Agent:
            HStack {
                Text(message.text)
                    .agentMessageStyle()
                    .offset(y: offset)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: duration)) {
                            scale = 1.0
                            opacity = 1.0
                            offset = 0
                        }
                    }
                Spacer()
            }
        case .User:
            HStack {
                Spacer()
                Text(message.text)
                    .userMessageStyle()
                    .opacity(opacity)
                    .offset(y: offset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: duration)) {
                            opacity = 1.0
                            offset = 0
                        }
                    }
            }
            .padding(.leading, 32)
        }
    }
}
