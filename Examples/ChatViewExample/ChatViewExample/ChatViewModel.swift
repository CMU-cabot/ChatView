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

import Foundation
import UIKit
import ChatView

public class ChatViewModel: ObservableObject  {
    @Published public var messages: [ChatMessage] = []
    @Published var power: Float = 0
    @Published var chatState: ChatState = .Inactive
    @Published var chatText: String = ""
    var stt = STTHelper()
    var tts = SimpleTTS.shared
    var client = ChatClientMock()

    public init() {
        stt.delegate = self
        stt.tts = SimpleTTS.shared
        client.delegate = self
    }
    public func startChat() {
        print("startChat")
        client.send(message: "")
    }
    private func process(text: String, for user: ChatUser) {
        print("process \(text) \(user)")
        messages.append(ChatMessage(user: user, text: text))
        switch user {
        case .Agent:
            self.stt.listen({ text, code in
                self.process(text: text, for: .User)
            }, selfvoice: text, speakendactions: nil, avrdelegate: nil, failure: { error in }, timeout: { })
        case .User:
            client.send(message: text)
        }
    }
}

extension ChatViewModel: ChatClientDelegate {
    public func receive(identifier: String, text: String) {
        process(text: text, for: .Agent)
    }
}

extension ChatViewModel: STTHelperDelegate {
    public func setPower(_ power: Float) {
        DispatchQueue.main.async {
            self.power = power
        }
    }
    public func showText(_ text: String, color: UIColor?) {
        print(text)
        DispatchQueue.main.async {
            self.chatText = text
        }
    }
    public func listen() {
        DispatchQueue.main.async {
            self.chatState = .Listening
        }
    }
    public func speak() {
        DispatchQueue.main.async {
            self.chatState = .Speaking
        }
    }
    public func recognize() {
        DispatchQueue.main.async {
            self.chatState = .Recognized
        }
    }
}
