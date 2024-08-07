//
//  LoadingView.swift
//  presentation
//
//  Created by Nihad Ismayilov on 29.07.24.
//

import SwiftUI

struct LoadingViewUI: View {
    @State private var rotation: Double = 0
    @State private var rotate = false {
        didSet {
            startRotating()
        }
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .neutral800).opacity(0.1).edgesIgnoringSafeArea(.all)
            Circle()
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [Color(uiColor: .red600).opacity(0.1), Color(uiColor: .red600)]), center: .center), lineWidth: 5
                )
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(rotation))
                .animation(rotate ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .none, value: rotation)
                .onAppear {
                    rotate = true
                }
        }
    }
    
    private func startRotating() {
        rotation = 360
    }
}

#Preview {
    LoadingViewUI()
}
