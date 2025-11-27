//
//  updateUserNoteUseCase.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 19/11/2025.
//

import AppCore

class UpdateUserNoteUseCase{
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func invoke(note: Note) async -> DomainResponse<Note>{
        if(note.id == 0){
            let response = await self.noteRepository.addNote(note: note)
            switch response {
            case .Success(_):
                return .Success(data : note)
                
            case .Error(_, let message):
                return .Error(data: note, message: message)
            }
        }
        return await self.noteRepository.updateNote(note: note)
    }
}
