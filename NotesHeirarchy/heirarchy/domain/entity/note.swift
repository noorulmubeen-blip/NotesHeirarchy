//
//  note.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 19/11/2025.
//

struct Note : Identifiable, Decodable, Encodable{
    var id: Int
    var todo: String?
    var completeted : Bool?
    var userId: Int
}
