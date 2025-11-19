//
//  LoginRequest.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 18/11/2025.
//

struct LoginRequest: Encodable {
    let username: String
    let password: String
    let expiresInMins: Int
}
