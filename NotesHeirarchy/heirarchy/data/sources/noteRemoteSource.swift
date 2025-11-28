//
//  noteRemoteSource.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//
import AppCore

protocol NoteRemoteSource{
    func fetchNotes(pageNo: Int, pageSize: Int) async -> NetworkResponse<PaginatedData<Note>>
    func addNote(note: Note) async -> NetworkResponse<Note>
    func removeNote(noteId: Int) async -> NetworkResponse<Void>
    func updateNote(note: Note) async -> NetworkResponse<Note>
    func fetchUserNotes(userId: Int, pageNo: Int, pageSize: Int) async -> NetworkResponse<PaginatedData<Note>>
    func fetchSpecificNote(noteId: Int) async -> NetworkResponse<Note>
}
