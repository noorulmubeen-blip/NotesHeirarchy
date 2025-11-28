//
//  noteDetailViewModel.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 21/11/2025.
//
import Foundation
import AppCore
import Combine


class NoteDetailViewModel : ObservableObject {
    let _getSpecificNoteUseCase : GetSpecificNoteUseCase
    let _removeUserNoteUseCase : RemoveUserNoteUseCase
    let _updateNoteUseCase : UpdateUserNoteUseCase
    let selectedNoteId : Int
    
    
    @Published var chatState : UiState<Note> = .uiLoading(data: nil)
    @Published var navigateBack : Bool = false
    
    // MARK: Handle Debounce on Updates on notes
    private var cancellables = Set<AnyCancellable>()
    private let textUpdateSubject = PassthroughSubject<Note, Never>()
    private let debounceInterval: TimeInterval = 2
    
    init(_getSpecificNoteUseCase: GetSpecificNoteUseCase,
         _removeUserNoteUseCase: RemoveUserNoteUseCase,
         _updateNoteUseCase: UpdateUserNoteUseCase,
         noteId: Int) {
        self._getSpecificNoteUseCase = _getSpecificNoteUseCase
        self._removeUserNoteUseCase = _removeUserNoteUseCase
        self._updateNoteUseCase = _updateNoteUseCase
        self.selectedNoteId = noteId
        
        setupTextDebounce()
    }
    
    private func setupTextDebounce() {
        textUpdateSubject
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] debounceNote in
                self?.updateNoteInformation()
                
            }
            .store(in: &cancellables)
    }
    
    func getNotesDetail() {
        Task{
            await MainActor.run{
                chatState = .uiLoading(data: chatState.data )
            }
            let response = await _getSpecificNoteUseCase.invoke(noteId: self.selectedNoteId)
            await MainActor.run{
                switch (response){
                case .Error(let data ,let  message):
                    chatState = .uiError(message: message, errorException: nil, code: nil, data: data ?? nil)
                    
                case .Success(let data):
                    chatState = .uiSuccess(data: data)
                }
            }
        }
    }
    
    func deleteNote()  {
        Task {
            await MainActor.run{
                chatState = .uiLoading(data: chatState.data)
            }
            guard let note = chatState.data else {
                return
            }
            let response = await _removeUserNoteUseCase.invoke(note: note)
            switch(response){
            case .Error(_,let message):
                await MainActor.run{
                    chatState = .uiError(message: message, errorException: nil, code: nil, data: note)
                }
            case .Success(_):
                await MainActor.run{
                    chatState = .uiSuccess(data: note)
                    navigateBack = true
                }
            }
        }
    }
    
    func updateNoteText(text: String) {
        chatState = .uiLoading(data: chatState.data)
        if var currentNote = chatState.data {
            currentNote.todo = text
            chatState = .uiSuccess(data: currentNote)
            textUpdateSubject.send(currentNote)
        }
        
    }
    
    func updateNoteText(isCompleted: Bool) {
        chatState = .uiLoading(data: chatState.data)
        if var currentNote = chatState.data {
            currentNote.completeted = isCompleted
            chatState = .uiSuccess(data: currentNote)
            textUpdateSubject.send(currentNote)
        }
    }
    
    func updateNoteInformation() {
        Task{
            await MainActor.run{
                chatState = .uiLoading(data: chatState.data)
            }
            guard let note = chatState.data else {
                return
            }
            let response = await _updateNoteUseCase.invoke(note: note)
            await MainActor.run{
                switch(response){
                case .Error(_,let message):
                    chatState = .uiError(message: message, errorException: nil, code: nil, data: note)
                    
                case .Success(let data):
                    chatState = .uiSuccess(data: data)
                }
            }
        }
    }
    
    func onBackPressed(){
        Task{
            await MainActor.run{
                chatState = .uiLoading(data: chatState.data)
            }
            guard let note = chatState.data else {
                return
            }
            let response = await _updateNoteUseCase.invoke(note: note)
            await MainActor.run{
                switch(response){
                case .Error(_,let message):
                    chatState = .uiError(message: message, errorException: nil, code: nil, data: note)
                    
                case .Success(let data):
                    chatState = .uiSuccess(data: data)
                    navigateBack = true
                }
            }
        }
    }
}
