//
//  networkResponse.swift
//
//
//  Created by Noor ul Mubeen on 22/09/2025.
//
public enum NetworkResponse<T>{
    case success(T)
    case error(message: String, code?= nil, data ?= nil: T?)
    case exception(Error)
}


extension NetworkResponse {
    func toDomainResponse() -> DomainResponse<T> {
        switch self {
        case .success(let data):
            return .success(data)
            
        case .error(let message, _, let data):
            return .error(data: data, message: message)
            
        case .exception(let error):
            return .error(data: nil, message: error.localizedDescription)
        }
    }
}
