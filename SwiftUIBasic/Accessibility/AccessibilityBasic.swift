//
//  AccessibilityBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/15.
//

import SwiftUI

struct AccessibilityBasic: View {
    @State private var isLiked = false
    var body: some View {
        Button {
            isLiked.toggle()
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
        }
        .font(.largeTitle)
        .accessibilityLabel("Like")
        .accessibilityValue(isLiked ? "like" : "unlike")
        .accessibilityIdentifier("like_button_id")
    }
}

#Preview {
    AccessibilityBasic()
}
