//
//  loginView.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 19/11/2025.
//

import SwiftUI
import AppCore
import Swinject

struct LoginView: View {
    @Environment(\.injected) private var resolver: Resolver
    @StateObject private var viewModel: LoginViewModel
    
    init(resolver: Resolver) {
        _viewModel = StateObject(wrappedValue: resolver.resolve(LoginViewModel.self)!)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                LoadingContainer(uiState: viewModel.uiState, content: {
                    VStack(alignment: .leading) {
                        Text("Enter Username...")
                        TextFieldForState(
                            uiState: viewModel.userNameState,
                            onUpdate: viewModel.updateUserName(userName:),
                            placeHolder: "Please enter User name Here..."
                        )
                        
                        Text("Enter Password...")
                        TextFieldForObscureState(
                            uiState: viewModel.passwordState,
                            onUpdate: viewModel.updatePassword(password:),
                            placeHolder: "Please enter Password Here..."
                        )
                        Button(action: {
                            viewModel.loginUser()
                        }) {
                            Text("Submit")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .padding(.vertical)
                        .disabled(viewModel.isSubmitButtonDisabled)
                        
                        if case .uiError(let message, _, _, _) = viewModel.uiState {
                            Text(message).foregroundColor(.red)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                })
            }
            .navigationTitle("Notes")
            .navigationDestination(isPresented: $viewModel.navigateToUserNotes) {
                Text("User Notes")
                    .font(.title)
                    .padding()
            }
        }
    }
}
