//
//  removeUserNoteUseCase.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 19/11/2025.
//
import AppCore

class RemoveUserNoteUseCase {
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func invoke(note: Note) async -> DomainResponse<Void> {
        return await noteRepository.removeNote(noteId: note.id)
    }
}
