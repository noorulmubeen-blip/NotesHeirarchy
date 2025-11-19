//
//  loginViewModel.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 19/11/2025.
//

import Foundation
import ValidationModule
import AppCore

class LoginViewModel : ObservableObject {
    @Published var navigateToUserNotes : Bool = false
    @Published var userNameState: UiState<String> = .uiIdle(data: "")
    @Published var passwordState: UiState<String> = .uiIdle(data: "")
    @Published var uiState: UiState<User?> = .uiLoading(data:nil)
    let getCurrentUserUseCase : GetCurrentUserUseCase
    let loginUserWithEmailUseCase: LoginUserWithEmailUseCase
    let validateShortStringUseCase : ValidateShortStringUseCase
    let validatePasswordUseCase : ValidatePasswordUseCase
    
    init(
        getCurrentUserUseCase: GetCurrentUserUseCase, loginUserWithEmailUseCase: LoginUserWithEmailUseCase,
        validateShortStringUseCase: ValidateShortStringUseCase, validatePasswordUseCase: ValidatePasswordUseCase) {
            self.getCurrentUserUseCase = getCurrentUserUseCase
            self.loginUserWithEmailUseCase = loginUserWithEmailUseCase
            self.validateShortStringUseCase = validateShortStringUseCase
            self.validatePasswordUseCase = validatePasswordUseCase
            
            getCurrentUser()
        }
    
    
    func getCurrentUser(){
        Task{
            let response  = await self.getCurrentUserUseCase.invoke()
            await MainActor.run{
                switch response {
                case .Success(let user):
                    self.uiState = .uiSuccess(data: user)
                    self.navigateToUserNotes = true
                    
                case .Error(_, _):
                    self.uiState = .uiSuccess(data: nil)
                }
            }
        }
    }
    
    func updateUserName(userName: String){
        self.userNameState = .uiLoading(data: userName)
        let response = self.validateShortStringUseCase.invoke(input: userName, maxLength: 25)
        switch (response){
        case .success(_):
            self.userNameState = .uiSuccess(data: userName)
            
        case .failure(_, let message):
            self.userNameState = .uiError(message: message ?? "", errorException: nil, code: nil, data: userName)
        }
    }
    
    func updatePassword(password: String){
        self.passwordState = .uiLoading(data: password)
        let response = self.validatePasswordUseCase.invoke(password: password)
        switch (response){
        case .success(_):
            self.passwordState = .uiSuccess(data: password)
            
        case .failure(_, let message):
            self.passwordState = .uiError(message: message ?? "", errorException: nil, code: nil, data: password)
        }
    }
    
    func loginUser(){
        self.uiState = .uiLoading(data: nil)
        self.updateUserName(userName: self.userNameState.data ?? "")
        self.updatePassword(password: self.passwordState.data ?? "")
        if case let UiState.uiSuccess(emailInput) = self.userNameState , case let UiState.uiSuccess(data: passwordInput) = self.passwordState{
            Task{
                let response = await self.loginUserWithEmailUseCase.invoke(email: emailInput, password: passwordInput)
                await MainActor.run{
                    switch response {
                    case .Success(let user):
                        self.uiState = .uiSuccess(data: user)
                        self.navigateToUserNotes = true
                        
                    case .Error(_, let message):
                        self.uiState = .uiError(message: message, errorException: nil, code: nil, data: nil)
                    }
                }
            }
        }
        else {
            self.uiState = .uiIdle(data: nil)
        }
    }
    
    func resetNavigation(){
        self.navigateToUserNotes = false
    }
    var isSubmitButtonDisabled: Bool {
        switch (userNameState, passwordState, uiState) {
        case (.uiSuccess, .uiSuccess, .uiSuccess),
            (.uiSuccess, .uiSuccess, .uiError),
            (.uiSuccess, .uiSuccess, .uiIdle):
            return false
        default:
            return true
        }
    }
}
