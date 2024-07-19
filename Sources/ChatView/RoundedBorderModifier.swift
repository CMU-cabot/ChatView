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

struct RoundedBorderModifier: ViewModifier {
    var backgroundColor: Color
    var borderColor: Color
    var cornerRadius: CGFloat
    var lineWidth: CGFloat
    var horizontalPadding: CGFloat
    var verticalPadding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}

extension View {
    func roundedBorderStyle(
        backgroundColor: Color = .white,
        borderColor: Color = .blue,
        cornerRadius: CGFloat = 20,
        lineWidth: CGFloat = 2,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 8
    ) -> some View {
        self.modifier(RoundedBorderModifier(
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            cornerRadius: cornerRadius,
            lineWidth: lineWidth,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding
        ))
    }
}

