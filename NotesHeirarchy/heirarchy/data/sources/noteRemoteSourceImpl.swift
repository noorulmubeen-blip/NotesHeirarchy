//
//  noteRemoteSourceImpl.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//

import AppCore
import Foundation

class NoteRemoteSourceImpl: NoteRemoteSource {
    final var apiClient: APIClient
    
    init( apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchNotes(pageNo: Int, pageSize: Int = 10) async -> NetworkResponse<PaginatedData<Note>> {
        let skipItems = (pageNo - 1 ) * pageSize
        guard let requestUrl = URL(string: "https://dummyjson.com/todos?limit=\(pageSize)&skip=\(skipItems)") else {
            return NetworkResponse.exception(NetworkError.invalidUrl)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let notes: NotesResponseDto = try await apiClient.getRequest(request)
            let totalPages = notes.total / pageSize + 2
            
            return NetworkResponse.success(data : PaginatedData<Note>(
                pageNo: pageNo,
                totalItems: notes.total,
                pageSize: pageSize,
                totalPages: totalPages,
                data : notes.todos,
            )
            )
        } catch {
            return NetworkResponse.exception(error)
        }
    }
    
    func addNote(note: Note) async -> NetworkResponse<Note> {
        guard let requestUrl = URL(string: "https://dummyjson.com/todos/add") else {
            return NetworkResponse.exception(NetworkError.invalidUrl)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = NoteRequest(
            todo: note.todo ?? "",
            completed: note.completeted ?? false,
            userId: note.userId
        )
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return NetworkResponse.exception(error)
        }
        do {
            let note: Note = try await self.apiClient.postRequest(request)
            return NetworkResponse.success(data : note)
        }
        catch let APIClientError.server(message, status) {
            return NetworkResponse.error(message: message, code: status, data: nil)
        }
        catch {
            return NetworkResponse.exception(error)
        }
        
    }
    
    func removeNote(noteId: Int) async -> NetworkResponse<Void> {
        guard let requestUrl = URL(string:"https://dummyjson.com/todos/\(noteId)")
        else {
            return NetworkResponse.exception(NetworkError.invalidUrl)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let _: EmptyResponse = try await self.apiClient.getRequest(request)
            return NetworkResponse.success(data : ())
        } catch {
            return NetworkResponse.exception(error)
        }
    }
    
    func updateNote(note: Note) async -> NetworkResponse<Note> {
        guard let requestUrl = URL(string: "https://dummyjson.com/todos/\(note.id)") else {
            return NetworkResponse.exception(NetworkError.invalidUrl)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = NoteRequest(
            todo: note.todo ?? "",
            completed: note.completeted ?? false,
        )
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return NetworkResponse.exception(error)
        }
        do {
            let note: Note = try await self.apiClient.postRequest(request)
            return NetworkResponse.success(data : note)
        }
        catch let APIClientError.server(message, status) {
            return NetworkResponse.error(message: message, code: status, data: nil)
        }
        catch {
            return NetworkResponse.exception(error)
        }
    }
    
    func fetchUserNotes(userId: Int, pageNo : Int, pageSize: Int) async -> NetworkResponse<PaginatedData<Note>> {
        let skipItems = (pageNo - 1 ) * pageSize
        guard let requestUrl = URL(string:"https://dummyjson.com/todos/user/\(userId)?limit=\(pageSize)&skip=\(skipItems)")
        else {
            return NetworkResponse.exception(NetworkError.invalidUrl)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let notes: NotesResponseDto = try await apiClient.getRequest(request)
            let totalPages = notes.total / pageSize + 1
            
            
            return NetworkResponse.success(data : PaginatedData<Note>(
                pageNo: pageNo,
                totalItems: notes.total,
                pageSize: pageSize,
                totalPages: totalPages,
                data : notes.todos,
            )
            )
        } catch {
            return NetworkResponse.exception(error)
        }
    }
    
    func fetchSpecificNote(noteId: Int) async -> NetworkResponse<Note> {
        guard let requestUrl = URL(string:"https://dummyjson.com/todos/\(noteId)")
        else {
            return NetworkResponse.exception(NetworkError.invalidUrl)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let noteResponse: Note = try await self.apiClient.getRequest(request)
            return NetworkResponse.success(data : noteResponse)
        } catch {
            return NetworkResponse.exception(error)
        }
    }
}
