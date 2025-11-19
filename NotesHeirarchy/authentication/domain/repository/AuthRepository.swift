//
//  AuthRepository.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 17/11/2025.
//
import AppCore

protocol AuthRepository {
    func getCurrentUser() async -> DomainResponse<User?>
    func loginUser(email: String, password: String) async -> DomainResponse<User?>
    func logoutUser() async -> DomainResponse<Void>
}
