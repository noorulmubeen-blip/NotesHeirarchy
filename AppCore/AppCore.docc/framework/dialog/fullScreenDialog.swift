//
//  fullScreenDialog.swift
//
//
//  Created by Noor ul Mubeen on 22/09/2025.
//

import SwiftUI
// inside framework

public struct LoadingContainer<T, Content: View>: View {
    public let uiState: UiState<T>
    public let content: Content
    
    public init(uiState: UiState<T>, @ViewBuilder content: () -> Content) {
        self.uiState = uiState
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            content
        }
        // TODO: Fix fullScreenCover logic
    }
}

public struct FullScreenDialog: View {
    public init() {}   // <--- Add public initializer
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("This is a fullscreen dialog")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Button("Dismiss") {
                    // TODO: Add dismissal binding
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(12)
            }
        }
    }
}
