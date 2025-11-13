//
//  uiState.swift
//  
//
//  Created by Noor ul Mubeen on 22/09/2025.
//

public enum UiState<T>{
    public case success(T)
    public case loading(data: T?)
    public case error(data: T?, message: String)
}
