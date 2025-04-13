//
//  View+.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/01.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func stroke(color: Color, width: CGFloat = 1) -> some View {
        modifier(StrokeBackground(strokeSize: width, strokeColor: color))
    }
    
    @ViewBuilder
    func backgroundImage(_ image: Image = Image(.background)) -> some View {
        self
            .background(
                image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .padding(-3)
            )
    }
    
    @ViewBuilder
    func pokemonBackground() -> some View {
        let background = LinearGradient(gradient: Gradient(colors: [Color.originalPurple1, Color.originalPurple2]), startPoint: .top, endPoint: .bottom)
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                background
                    .ignoresSafeArea()
            )
    }
    
    @ViewBuilder
    func pokemonButtonStyle() -> some View {
        self
            .buttonStyle(.plain)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 10)
    }
}
