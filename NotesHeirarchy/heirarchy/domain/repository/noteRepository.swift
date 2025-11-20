//
//  noteRepository.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 19/11/2025.
//
import AppCore

protocol NoteRepository {
    func fetchNotes(pageNo: Int, pageSize: Int) async -> DomainResponse<PaginatedData<Note>>
    func fetchUserNotes(userId : Int,pageNo: Int, pageSize: Int) async -> DomainResponse<PaginatedData<Note>>
    func addNote(note: Note) async -> DomainResponse<Void>
    func removeNote(noteId: Int) async -> DomainResponse<Void>
    func updateNote(note: Note) async -> DomainResponse<Note>
    func getSpecificNote(noteId: Int) async -> DomainResponse<Note>
}
