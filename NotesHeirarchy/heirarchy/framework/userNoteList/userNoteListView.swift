//
//  userNoteListView.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 24/11/2025.
//


import AppCore
import Swinject
import SwiftUI

struct UserNoteListView: View {
    @Environment(\.injected) private var resolver : Resolver
    @StateObject private var viewModel : UserNoteListViewModel
    
    init(resolver: Resolver) {
        _viewModel = StateObject(
            wrappedValue: resolver.resolve(UserNoteListViewModel.self)!
        )
    }
    
    
    var body : some View {
        NavigationView{
            let notes = viewModel.chatListState.data?.compactMap { $0 } ?? []
            
            VStack {
                List {
                    ForEach(notes) { item in
                        if item.id < 0 {
                            ProgressView().id(UUID())
                                .frame(maxWidth: .infinity)
                        } else {
                            
                            NavigationLink(destination: NoteDetailView(resolver: resolver, noteId: item.id)) {
                                Text(item.todo ?? "Untitled Note")
                                    .onAppear {
                                        if item.id == notes.last?.id {
                                            viewModel.getLastestNoteList()
                                        }
                                    }
                            }
                        }
                    }
                }
                .navigationBarTitle("Notes")
                .onAppear{
                    viewModel.getLastestNoteList(clearPrevious: true)
                }
                .overlay {
                    if case .uiLoading(_) = self.viewModel.chatListState {
                        ProgressView("Loading User Notes...").id(UUID())
                    }
                }
                
            }
        }
    }
}
