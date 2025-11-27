//
//  getSpecificNoteUseCase.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//
import AppCore

class GetSpecificNoteUseCase{
    let noteRepository: NoteRepository
    let appEnvironment : AppEnvironment
    
    init(noteRepository: NoteRepository, appEnvironment: AppEnvironment) {
        self.noteRepository = noteRepository
        self.appEnvironment = appEnvironment
    }
    
    func invoke(noteId: Int) async  -> DomainResponse<Note>{
        if(noteId == 0) {
            return .Success(data: Note(id: 0, userId: self.appEnvironment.currentUser.id))
        }
        
        return await self.noteRepository.getSpecificNote(noteId: noteId)
    }
}
