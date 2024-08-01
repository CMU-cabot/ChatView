/*******************************************************************************
 * Copyright (c) 2014, 2024  IBM Corporation, Carnegie Mellon University and others
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
import UIKit
import ChatView
import AVFoundation

class SimpleTTS: NSObject, TTSProtocol, AVSpeechSynthesizerDelegate {

    static var shared = SimpleTTS()

    var map: [String: ()->Void] = [:]
    var synthe = AVSpeechSynthesizer()
    var text: String = ""
    var cancellables = Set<AnyCancellable>()

    func speak(_ text:PassthroughSubject<String, any Error>?, callback: @escaping ()->Void) {
        guard let text else {
            callback()
            return
        }

        text.sink(receiveCompletion: { _ in
            self.synthe.delegate = self
            let u = AVSpeechUtterance(string: self.text)
            self.map[self.text] = callback
            NSLog("speech started: "+self.text)
            self.synthe.speak(u)
            self.text = ""
        }, receiveValue: { chunk in
            self.text.append(chunk)
        })
        .store(in: &cancellables)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        NSLog("speech finished: "+utterance.speechString)
        if let callback = map[utterance.speechString] {
            callback()
        }
        synthe.stopSpeaking(at: .immediate)
    }
    
    func stop() {
        synthe.stopSpeaking(at: .word)
    }

    func stop(_ immediate: Bool) {
        synthe.stopSpeaking(at: .immediate)
    }
    
    func vibrate() {
        print("needs to implement vibrate")
    }
    
    func playVoiceRecoStart() {
        print("needs to implement playVoiceRecoStart")
    }
}
