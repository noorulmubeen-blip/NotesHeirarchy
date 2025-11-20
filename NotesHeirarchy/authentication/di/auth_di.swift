//
//  auth_di.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 17/11/2025.
//
import Swinject
import AppCore
import ValidationModule



public final class AuthAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        //MARK: - Network Layer
        
        container.register(AuthRemoteSource.self) { r in
            AuthRemoteSourceImpl(apiClient: r.resolve(APIClient.self)!)
        }
        
        container.register(AuthRepository.self) { r in
            AuthRepositoryImpl(authRemoteSource: r.resolve(AuthRemoteSource.self)!, preferenceStorage: r.resolve(PreferenceStorage.self)!)
        }
        
        // MARK: - Use Cases
        
        container.register(GetCurrentUserUseCase.self) { r in
            GetCurrentUserUseCase(authRepository: r.resolve(AuthRepository.self)!)
        }
        
        container.register(LoginUserWithEmailUseCase.self) { r in
            LoginUserWithEmailUseCase(authRepsitory: r.resolve(AuthRepository.self)!)
        }
        // MARK: ViewModels
        
        container.register(LoginViewModel.self) { r in
            LoginViewModel(
                getCurrentUserUseCase: r.resolve(GetCurrentUserUseCase.self)!,
                loginUserWithEmailUseCase: r.resolve(LoginUserWithEmailUseCase.self)!,
                validateShortStringUseCase: r.resolve(ValidateShortStringUseCase.self)!,
                validatePasswordUseCase: r.resolve(ValidatePasswordUseCase.self)!)
        }
        
    }
}
