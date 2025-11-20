//
//  di_app.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 22/09/2025.
//
import SwiftUI
import Foundation
import ValidationModule
import AppCore
import Swinject

final class AppContainer {
    static let shared = AppContainer()   // Singleton container
    let container: Container
    
    private init() {
        container = Container()
        registerServices()
    }
    
    private func registerServices() {
        Assembler([
            AppCoreAssembly(),
            ValidationAssembly(),
            AuthAssembly(),
            NoteAssembly(),
        ], container: container)
        container.register(ContentViewModel.self) { resolver in
            ContentViewModel(stringValidator: resolver.resolve(ValidateShortStringUseCase.self)!)
        }
    }
}

private struct DIKey: EnvironmentKey {
    static let defaultValue: Resolver = AppContainer.shared.container
}

extension EnvironmentValues {
    var injected: Resolver {
        get { self[DIKey.self] }
        set { self[DIKey.self] = newValue }
    }
}
