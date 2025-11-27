//
//  getUserNoteUseCase.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 19/11/2025.
//
import AppCore

class GetUserNoteUseCase {
    let noteRepository: NoteRepository
    
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func invoke(userId: Int,pageNo: Int, pageSize: Int) async -> DomainResponse<PaginatedData<Note>>{
        return await self.noteRepository.fetchUserNotes(userId: userId, pageNo: pageNo, pageSize: pageSize)
    }
}
