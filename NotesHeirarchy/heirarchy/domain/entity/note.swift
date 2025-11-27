//
//  note.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 19/11/2025.
//

struct Note : Identifiable, Decodable, Encodable, Equatable, Hashable{
    let id: Int
    var todo: String?
    var completeted : Bool?
    let userId: Int
}
