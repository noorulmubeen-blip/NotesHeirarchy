//
//  AuthRemoteSourceImpl.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 17/11/2025.
//
import AppCore
import Foundation

class AuthRemoteSourceImpl : AuthRemoteSource{
    final var apiClient: APIClient
    
    init( apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    
    func loginUser(email: String, password: String) async -> NetworkResponse<RemoteUserDto?> {
        guard let requestUrl = URL(string: "https://dummyjson.com/auth/login") else {
            return NetworkResponse.exception(NetworkError.invalidUrl)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(
            username: email,
            password: password,
            expiresInMins: 30
        )
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return NetworkResponse.exception(error)
        }
        do {
            // Use APIClient's generic decoding capability to avoid tuple inference
            let user: RemoteUserDto = try await self.apiClient.postRequest(request)
            return NetworkResponse.success(data : user)
        }
        catch let APIClientError.server(message, status) {
            return NetworkResponse.error(message: message, code: status, data: nil)
       }
        catch {
            // If APIClient throws an error that includes status code/message, surface it; otherwise, wrap as exception
            return NetworkResponse.exception(error)
        }
        
    }
    
    func getCurrentUser() async -> NetworkResponse<RemoteUserDto?> {
        guard let requestUrl = URL(string: "https://dummyjson.com/auth/me") else {
            return NetworkResponse.exception(NetworkError.invalidUrl)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let user: RemoteUserDto = try await self.apiClient.getRequest(request)
            return NetworkResponse.success(data : user)
        } catch {
            return NetworkResponse.exception(error)
        }
    }
    
    func logoutUser() -> NetworkResponse<Void> {
        return NetworkResponse.error(message: "Not implemented", code: nil, data: nil)
    }
    
    func refreshUser() -> NetworkResponse<RemoteUserDto?> {
        return NetworkResponse.error(message: "Not implemented", code: nil, data: nil)
    }
    
    
    
    
}
