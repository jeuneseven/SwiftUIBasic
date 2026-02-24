//
//  Watermark.swift
//  SwiftUIBasic
//
//  Created by seven on 2026/2/24.
//
import SwiftUI

struct Watermark: ViewModifier {
    var text: String // custom view modifier can has their own property

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View { // extension a view can not have their own property
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}
