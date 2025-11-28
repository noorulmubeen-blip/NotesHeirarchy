//
//  noteRepositoryImpl.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 19/11/2025.
//
import AppCore

class NoteRepositoryImpl : NoteRepository {
    let noteRemoteSource: NoteRemoteSource
    
    init(noteRemoteSource: NoteRemoteSource) {
        self.noteRemoteSource = noteRemoteSource
    }
    
    func fetchNotes(pageNo: Int, pageSize: Int) async -> DomainResponse<PaginatedData<Note>> {
        let response = await noteRemoteSource.fetchNotes(pageNo: pageNo, pageSize: pageSize)
        let domainResponse = response.toDomainResponse()
        return domainResponse
    }
    
    func fetchUserNotes(userId: Int, pageNo: Int, pageSize: Int) async -> DomainResponse<PaginatedData<Note>> {
        let response = await noteRemoteSource.fetchUserNotes(userId: userId, pageNo: pageNo, pageSize: pageSize)
        let domainResponse = response.toDomainResponse()
        return domainResponse
    }
    
    func addNote(note: Note) async -> DomainResponse<Note> {
        let response = await noteRemoteSource.addNote(note: note)
        return response.toDomainResponse()
    }
    
    func removeNote(noteId: Int) async -> DomainResponse<Void> {
        let response = await noteRemoteSource.removeNote(noteId: noteId)
        return response.toDomainResponse()
    }
    
    func updateNote(note: Note) async -> DomainResponse<Note> {
        let response = await noteRemoteSource.updateNote(note: note)
        return response.toDomainResponse()
    }
    
    func getSpecificNote(noteId: Int) async -> DomainResponse<Note> {
        let response = await noteRemoteSource.fetchSpecificNote(noteId: noteId)
        return response.toDomainResponse()
    }
    
}
