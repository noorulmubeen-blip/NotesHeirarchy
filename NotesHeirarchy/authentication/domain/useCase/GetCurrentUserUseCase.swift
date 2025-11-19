//
//  GetCurrentUserUseCase.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 17/11/2025.
//
import AppCore

class GetCurrentUserUseCase{
    final var authRepository : AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func invoke() async -> DomainResponse<User?> {
        return await authRepository.getCurrentUser()
    }
}
