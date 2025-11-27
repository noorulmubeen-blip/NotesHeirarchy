//
//  userNoteListViewModel.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 24/11/2025.
//
import Foundation
import AppCore

class UserNoteListViewModel : ObservableObject{
    let _getUserNoteListUseCase: GetUserNoteUseCase
    let _deleteSpecificUser: RemoveUserNoteUseCase
    let _appEnvironment: AppEnvironment
    
    @Published var chatListState : UiState<[Note?]> = .uiLoading(data: [])
    @Published var navigateToAddNote : Bool = false
    @Published var navigateToNoteDetail : Int = 0
    private var currentPageNo : Int = 1
    private var maxPageNo: Int = 2
    private var pageSize: Int  = 10
    let userId : Int
    
    init(_getUserNoteListUseCase: GetUserNoteUseCase, _deleteSpecificUser: RemoveUserNoteUseCase, appEnvironment : AppEnvironment) {
        self._getUserNoteListUseCase = _getUserNoteListUseCase
        self._deleteSpecificUser = _deleteSpecificUser
        self._appEnvironment = appEnvironment
        self.userId = self._appEnvironment.currentUser.id
    }
    
    func getLastestNoteList(clearPrevious: Bool = false) {
        let progressNote = Note(id: -1, todo: nil, completeted: nil, userId: 0)
        if(clearPrevious){
            currentPageNo = 1
            maxPageNo = 2
        }
        if(currentPageNo >= maxPageNo){
            return;
        }
        
        Task{
            await MainActor.run{
                let notes = if (!clearPrevious){ (self.chatListState.data ?? []) + [progressNote]
                } else {
                    []
                } as [Note?]
                self.chatListState = .uiLoading(data: notes)
                
            }
            try await Task.sleep(for: .seconds(2))
            let response = await _getUserNoteListUseCase.invoke(userId : self.userId,pageNo: currentPageNo, pageSize: pageSize)
            switch response{
            case .Success(let notes):
                self.currentPageNo = notes.pageNo + 1
                self.maxPageNo = notes.totalPages
                await MainActor.run{
                    let old = (self.chatListState.data?.compactMap { $0 } ?? []).filter { $0.id > 0 }
                    let new = notes.data.compactMap { $0 }
                    
                    var merged = Array(Set(old + new)).sorted { $0.id < $1.id }
                    if (self.currentPageNo < maxPageNo){
                        merged = merged
                    }
                    self.chatListState = .uiSuccess(data: merged)
                }
            case .Error(_, let message):
                await MainActor.run{
                    let old = (self.chatListState.data ?? []).filter { $0 != nil && $0?.id ?? -1  > 0 }.compactMap{ $0 }
                    self.chatListState = .uiError(message: message, errorException: nil, code: nil, data: old)
                }
            }
        }
    }
    
    func onNavigateToAddNewNote(){
        navigateToAddNote = true
    }
    
    func resetNavigation(){
        navigateToAddNote = false
        navigateToNoteDetail = 0
    }
    
    func onNavigateToNoteDetail(noteId: Int){
        navigateToNoteDetail = noteId
    }
    
    func onDeleteNote(note : Note) {
        self.chatListState = .uiLoading(data: self.chatListState.data)
        Task {
            let response = await _deleteSpecificUser.invoke(note: note)
            switch response{
            case .Success(_):
                await MainActor.run{
                    let notes = (self.chatListState.data ?? []).compactMap { $0 }
                    self.chatListState = .uiSuccess(data: notes.filter { $0.id != note.id })
                }
            case .Error(_, let message):
                await MainActor.run{
                    self.chatListState = .uiError(message: message, errorException: nil, code: nil, data: self.chatListState.data ?? [])
                }
            }
        }
    }
}
