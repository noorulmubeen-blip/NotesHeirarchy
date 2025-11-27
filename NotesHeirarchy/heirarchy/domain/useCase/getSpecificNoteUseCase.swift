//
//  getSpecificNoteUseCase.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//
import AppCore

class GetSpecificNoteUseCase{
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func invoke(noteId: Int) async  -> DomainResponse<Note>{
        return await self.noteRepository.getSpecificNote(noteId: noteId)
    }
}
