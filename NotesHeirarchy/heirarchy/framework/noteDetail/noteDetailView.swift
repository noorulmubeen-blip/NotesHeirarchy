//
//  noteDetailView.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 21/11/2025.
//
import Swinject
import SwiftUI
import AppCore


struct NoteDetailView : View {
    @Environment(\.injected) private var resolver : Resolver
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel : NoteDetailViewModel
    
    init(resolver: Resolver, noteId: Int) {
        _viewModel =  StateObject(
            wrappedValue: resolver.resolve(NoteDetailViewModel.self, argument: noteId)!
        )
    }
    
    var body: some View {
        let note = viewModel.chatState.data
        UiContainer(uiState: viewModel.chatState) {
            VStack(alignment: .leading){
                if note?.id ?? -1 < 0 {
                    ProgressView("Loading Note...")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                else {
                    Text(note?.todo ?? "Untitled Note")
                        .padding(.vertical, 8).multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        TextEditorForState(
                            uiState: .uiSuccess(data : viewModel.chatState.data?.todo ?? ""),
                            onUpdate: viewModel.updateNoteText(text:),
                            placeHolder: "Please enter Notes Details name Here..."
                        )
                        .frame(maxHeight : 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        Image(systemName: "trash")
                            .symbolRenderingMode(.multicolor)
                            .frame(width: 16,)
                            .onTapGesture{
                                self.viewModel.deleteNote()
                            }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .navigationTitle( "Note Detail")
            .onChange(of: viewModel.navigateBack ){
                dismiss()
            }
        }
        .onAppear {
            viewModel.getNotesDetail()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.onBackPressed()
                }) {
                    Label("Notes List", systemImage: "chevron.left")
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
}
