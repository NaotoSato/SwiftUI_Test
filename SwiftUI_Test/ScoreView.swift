//
//  ScoreView.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/03/31.
//

import SwiftUI

struct ScoreView: View {
    let scoreText: String
    
    var body: some View {
        VStack {
            Spacer()
            Text(scoreText)
                .font(.system(size: 40).bold())
                .foregroundStyle(.originalYellow)
                .stroke(color: .originalGreen, width: 5)
            Spacer()
            Button {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.windows.first?.rootViewController?.dismiss(animated: true)
            } label: {
                Image(.topButton)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage()
    }
}

#Preview {
    ScoreView(scoreText: "")
}
