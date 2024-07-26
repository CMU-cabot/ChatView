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


struct MicrophoneButton: UIViewRepresentable {
    class Delegate: DialogViewDelegate {
        public var callback: (()->Void)?
        func dialogViewTapped() {
            if let callback = self.callback {
                callback()
            }
        }
    }
    public let helper = DialogViewHelper()
    public let delegate = Delegate()
    init(action callback: (()->Void)? = nil) {
        self.delegate.callback = callback
    }
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        helper.setup(view, position: CGPoint(x: 75, y: 75))
        helper.delegate = self.delegate
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

#Preview("listen") {
    let view = MicrophoneButton()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        view.helper.listen()
    }
    return view

}

#Preview("recognize") {
    let view = MicrophoneButton()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        view.helper.recognize()
    }
    return view
}

#Preview("speak") {
    let view = MicrophoneButton()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        view.helper.speak()
    }
    return view
}

#Preview("inactive") {
    let view = MicrophoneButton()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        view.helper.inactive()
    }
    return view
}
