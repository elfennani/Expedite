//
//  PrimaryButtonStyle.swift
//  Expedite
//
//  Created by Nizar Elfennani on 12/7/2025.
//

import SwiftUI


struct PrimaryButtonStyle: ButtonStyle {
    @State private var isHovered = false;
    @Environment(\.isEnabled) var isEnabled
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        let isDark = colorScheme == .dark
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(!isEnabled ? (isDark ? .grayscale3 : .grayscale4) : .grayscale1)
            .foregroundStyle(!isEnabled ? (isDark ? .grayscale4 : .grayscale3) : .white)
            .overlay(
                .white.opacity(isHovered ? 0.05 : 0)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .onHover(perform: {hovering in
                isHovered = hovering
            })
            .cornerRadius(8)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
    }
}
