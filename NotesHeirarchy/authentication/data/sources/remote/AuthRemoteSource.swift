//
//  AuthRemoteSource.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 17/11/2025.
//
import AppCore

protocol AuthRemoteSource{
    func  loginUser(email: String, password: String) async -> NetworkResponse<RemoteUserDto?>
    func getCurrentUser() async -> NetworkResponse< RemoteUserDto?>
    func logoutUser() async -> NetworkResponse<Void>
    func refreshUser() async -> NetworkResponse<RemoteUserDto?>
}
