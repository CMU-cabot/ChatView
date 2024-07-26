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

public struct ChatStateButton: View {
    private let action: (()->Void)?
    private let view: ChatStateButtonViewWrapper
    init(action: (()->Void)? = nil, state: Binding<ChatState>) {
        self.action = action
        self.view = ChatStateButtonViewWrapper(action: action, state: state)
    }

    public var body: some View {
        view
    }
}

struct ChatStateButtonViewWrapper: UIViewRepresentable {
    class Delegate: ChatStateButtonViewDelegate {
        public var action: (()->Void)?
        func dialogViewTapped() {
            if let action = self.action {
                action()
            }
        }
    }
    @Binding var state: ChatState
    public let animator = ChatStateButtonViewAnimator()
    public let delegate = Delegate()
    init(action: (()->Void)? = nil, state: Binding<ChatState>) {
        self._state = state
        self.delegate.action = action
    }
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        animator.setup(view, position: CGPoint(x: 75, y: 75))
        animator.delegate = self.delegate
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        switch self.state {
        case .Inactive:
            animator.inactive()
        case .Speaking:
            animator.speak()
        case .Listening:
            animator.listen()
        case .Recognized:
            animator.recognize()
        case .Unknown:
            animator.inactive()
        }
    }
}

#Preview("listen") {
    @State var state = ChatState.Inactive
    let view = ChatStateButton(state: $state)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        state = .Listening
    }
    return view

}

#Preview("recognize") {
    @State var state = ChatState.Inactive
    let view = ChatStateButton(state: $state)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        state = .Recognized
    }
    return view
}

#Preview("speak") {
    @State var state = ChatState.Inactive
    let view = ChatStateButton(state: $state)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        state = .Speaking
    }
    return view
}

#Preview("inactive") {
    @State var state = ChatState.Inactive
    let view = ChatStateButton(state: $state)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        state = .Inactive
    }
    return view
}
