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
import Foundation
import ChatView


class ChatClientMock: ChatClient {
    var callback: ChatClientCallback?
    let welcome_text = "Hello"
    init(callback: @escaping ChatClientCallback) {
        self.callback = callback
    }
    func send(message: String) {
        if message.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.call_callback(text: self.welcome_text)
            }
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.call_callback(text: message)
        }
    }

    func call_callback(text: String) {
        let pub = PassthroughSubject<String, any Error>()
        self.callback?(UUID().uuidString, pub)
        pub.send(text)
        pub.send(completion: .finished)
    }
}
