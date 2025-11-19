//
//  LoginUserWithEmail.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 17/11/2025.
//
import AppCore

class LoginUserWithEmailUseCase{
    final var authRepsitory : AuthRepository
    init(authRepsitory: AuthRepository){
        self.authRepsitory = authRepsitory
    }
    
    func invoke(email: String, password: String) async -> DomainResponse<User?>{
        return await self.authRepsitory.loginUser(email: email, password: password)
    }
}
