//
//  getNotesUseCase.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//
import AppCore

class GetNotesUseCase{
    let noteRepository : NoteRepository
    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }
    
    func invoke(pageNo: Int, pageSize: Int) async -> DomainResponse<PaginatedData<Note>>{
        return await self.noteRepository.fetchNotes(pageNo: pageNo, pageSize: pageSize)
    }
}
