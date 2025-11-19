//
//  RemoteUserDto.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 17/11/2025.
//

struct RemoteUserDto : Decodable{
    var id: Int
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var gender : String
    var image: String
    var accessToken: String?
    var refreshToken : String?
}
