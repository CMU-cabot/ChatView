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
    init(action: (()->Void)? = nil, state: Binding<ChatState>, text: Binding<String>) {
        self.action = action
        self.view = ChatStateButtonViewWrapper(action: action, state: state, text: text)
    }

    public var body: some View {
        view
    }
}

struct ChatStateButtonViewWrapper: UIViewRepresentable {
    class Coordinator: NSObject, ChatStateButtonViewDelegate {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        let animator = ChatStateButtonViewAnimator()
        var action: (()->Void)?
        override init() {
            animator.setup(view, position: CGPoint(x: 75, y: 75))
            super.init()
            animator.delegate = self
        }
        func dialogViewTapped() {
            if let action = self.action {
                action()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.action = action
        return coordinator
    }

    @Binding var state: ChatState
    @Binding var text: String
    private var action: (()->Void)?
    init(action: (()->Void)? = nil, state: Binding<ChatState>, text: Binding<String>) {
        self.action = action
        self._state = state
        self._text = text
        print("create animator")
    }
    func makeUIView(context: Context) -> UIView {
        print("makeUIView")
        return context.coordinator.view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        switch self.state {
        case .Inactive:
            context.coordinator.animator.inactive()
        case .Speaking:
            context.coordinator.animator.speak()
        case .Listening:
            context.coordinator.animator.listen()
        case .Recognized:
            context.coordinator.animator.recognize()
        case .Unknown:
            context.coordinator.animator.inactive()
        }
        context.coordinator.animator.showText(text)
    }
}

#Preview("listen") {
    @State var state = ChatState.Inactive
    @State var text = ""
    let view = ChatStateButton(state: $state, text: $text)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        state = .Listening
    }
    return view

}

#Preview("recognize") {
    @State var state = ChatState.Inactive
    @State var text = ""
    let view = ChatStateButton(state: $state, text: $text)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        state = .Recognized
    }
    return view
}

#Preview("speak") {
    @State var state = ChatState.Inactive
    @State var text = ""
    let view = ChatStateButton(state: $state, text: $text)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        state = .Speaking
    }
    return view
}

#Preview("inactive") {
    @State var state = ChatState.Inactive
    @State var text = ""
    let view = ChatStateButton(state: $state, text: $text)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        state = .Inactive
    }
    return view
}
