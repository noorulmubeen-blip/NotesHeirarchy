//
//  notesResposeDto.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//

struct NotesResponseDto : Decodable{
    var notes : [Note]
    var total : Int
    var skip : Int
    var limit : Int
}
