//
//  DogProgressView.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 09/08/2025.
//

import SwiftUI

struct DogProgressView: View {
    @State private var animate = false
    
    var body: some View {
        Image("bone-icon")
            .resizable()
            .frame(width: 100, height: 100)
            .rotationEffect(.degrees(Double.random(in: 0...90)))
            .rotationEffect(Angle(degrees: animate ? 370 : 0))
            .animation(
                .linear(duration: 0.6)
                .repeatForever(autoreverses: false),
                value: animate
            )
            .onAppear {
                withAnimation {
                    animate.toggle()
                }
            }
    }
}

#Preview {
    DogProgressView()
}
