//
//  app_env.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 24/11/2025.
//
import SwiftUI

class AppEnvironment : ObservableObject{
    @Published var currentUser: User = User(id: -1, name: "", email: "", firstName: "", lastName: "", gender: "" , image: " ")
    
    func setUser(user: User) {
        self.currentUser = user
    }
}
