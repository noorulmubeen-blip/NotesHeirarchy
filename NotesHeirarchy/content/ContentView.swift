//
//  ContentView.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 18/09/2025.
//

import SwiftUI
import AppCore
import Swinject

struct ContentView: View {
    @State private var state: UiState<String> = .uiLoading(data:"Hello")
    @Environment(\.injected) private var resolver: Resolver
    @StateObject private var viewModel: ContentViewModel
    
    init(resolver: Resolver) {
        _viewModel = StateObject(wrappedValue: resolver.resolve(ContentViewModel.self)!)
    }
    
    
    var body: some View {
        VStack {
            VStack{
                LoadingContainer(uiState: viewModel.uiState,content:
                                    {
                    Text("this is a text \(viewModel.uiState.data ?? "head sfa")")
                    if case .uiError(let message, _,_,_) = viewModel.uiState {
                        Text((message))
                            .foregroundColor(.red)
                    }
                }
                )
            } 
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                viewModel.resetState()
            }
            
        }
    }
}

