//
//  AuthRepositoryImpl.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 17/11/2025.
//

import AppCore

class AuthRepositoryImpl : AuthRepository{
    final var authRemoteSource : AuthRemoteSource
    final var preferenceStorage : PreferenceStorage
    
    init(authRemoteSource: AuthRemoteSource, preferenceStorage: PreferenceStorage) {
        self.authRemoteSource = authRemoteSource
        self.preferenceStorage = preferenceStorage
    }
    
    func getCurrentUser() async -> DomainResponse<User?> {
        if(preferenceStorage.getAccessToken() == nil || preferenceStorage.getAccessToken() == ""){
            return DomainResponse.Error(data: nil, message: "Missing Access Token")
        }
        
        let response = await authRemoteSource.getCurrentUser()
        let domainResponse = response.toDomainResponse()
        switch domainResponse {
        case .Success(let data):
            if(data == nil){
                return DomainResponse.Error(data: nil, message: "Something went wrong")
            }
            if(data!.accessToken != nil && data!.refreshToken != nil){
                self.preferenceStorage.setAccessToken(data?.accessToken ?? "")
                self.preferenceStorage.setRefreshToken(data?.accessToken ?? "")
            }
            
            let userDto = UserMapper.toDomain(data!)
            return DomainResponse.Success(data: userDto)
            
        case .Error(_,let message) :
            return DomainResponse.Error(data: nil, message: message)
        }
    }
    
    func loginUser(email: String, password: String) async -> AppCore.DomainResponse<User?> {
        let response = await authRemoteSource.loginUser(email: email, password: password)
        let domainResponse = response.toDomainResponse()
        switch domainResponse {
        case .Success(let data):
            if(data == nil){
                return DomainResponse.Error(data: nil, message: "Something went wrong")
            }
            
            self.preferenceStorage.setAccessToken(data!.accessToken ?? "")
            self.preferenceStorage.setRefreshToken(data!.accessToken ?? "")
            
            let userDto = UserMapper.toDomain(data!)
            return DomainResponse.Success(data: userDto)
            
        case .Error( _,let message) :
            return DomainResponse.Error(data: nil, message: message)
        }
    }
    
    func logoutUser() async -> AppCore.DomainResponse<Void> {
        let response = await authRemoteSource.logoutUser()
        let domainResponse = response.toDomainResponse()
        if case DomainResponse.Success(_) = domainResponse{
            
            preferenceStorage.removeAccessToken()
            preferenceStorage.removeRefreshToken()
            
        }
        
        return domainResponse
    }
}
