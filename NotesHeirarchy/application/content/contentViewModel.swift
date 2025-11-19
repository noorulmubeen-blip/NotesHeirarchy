//
//  contentViewModel.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 30/09/2025.
//

import Foundation
import ValidationModule
import Combine
import AppCore

class ContentViewModel: ObservableObject {
    @Published var notes: [String] = []
    @Published var uiState: UiState<String> = .uiLoading(data:"Hello world")
    private let stringValidator: ValidateShortStringUseCase
    
    @Published var isValid = false
    
    init(stringValidator: ValidateShortStringUseCase) {
        self.stringValidator = stringValidator
    }
    func addNote(_ note: String) {
        notes.append(note)
    }
    func resetState(){
        uiState = .uiLoading(data: "this is loading")
        sleep(3)
        let response = stringValidator.invoke(input: "thi sis sd fasfmksamlasmf ;lamfas; lfaklams;l dfa", maxLength: 25)
        switch response{
        case .success(let data):
            uiState = .uiSuccess( data: data ?? "dadasda")
        case .failure(let data, let message):
            uiState = .uiError(message: message ?? "message", errorException : nil
                               ,code: nil, data: data)
        }
    }
}
