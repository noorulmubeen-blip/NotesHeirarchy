//
//  noteRequest.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//

struct NoteRequest: Codable {
    var todo: String
    var completed: Bool
    var userId: Int?
}
