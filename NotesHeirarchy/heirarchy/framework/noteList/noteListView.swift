//
//  noteListView.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//

import AppCore
import Swinject
import SwiftUI

struct NoteListView: View {
    @Environment(\.injected) private var resolver : Resolver
    @StateObject private var viewModel : NoteListViewModel
    
    init(resolver: Resolver) {
        _viewModel = StateObject(
            wrappedValue: resolver.resolve(NoteListViewModel.self)!
        )
    }
    
    
    var body: some View {
        NavigationView {
            let notes: [Note] = (viewModel.chatListState.data ?? []).compactMap { $0 }
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(notes, id: \.id) { item in
                        VStack(alignment: .leading){
                            if item.id < 0 {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            }
                            else {
                                NavigationLink(
                                    destination: NoteDetailView(
                                        resolver: resolver,
                                        noteId: item.id
                                    )
                                ) {
                                    HStack{
                                        Text(item.todo ?? "Untitled Note")
                                            .padding(.vertical, 8).multilineTextAlignment(.leading)
                                            .padding(.horizontal)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .onAppear {
                                                if item.id == notes.last?.id {
                                                    viewModel.getLastestNoteList()
                                                }
                                            }
                                        Image(systemName: "trash")
                                            .symbolRenderingMode(.multicolor)
                                            .frame(width: 16,)
                                            .onTapGesture{
                                            viewModel.onRemoveNote(note: item)
                                            }
                                    }
                                    .padding(.horizontal, 16)
                                }
                                
                                Divider()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Notes")
            .background(Color(.secondarySystemBackground))
            .onAppear {
                if notes.isEmpty {
                    viewModel.getLastestNoteList()
                }
            }
            .overlay {
                if notes.count == 1 && notes.first?.id ?? 0 < 0 {
                    ProgressView("Loading Notes...")
                }
            }
        }
    }
}
