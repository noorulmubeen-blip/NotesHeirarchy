//
//  NotesHeirarchyApp.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 18/09/2025.
//

import SwiftUI

@main
struct NotesHeirarchyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(resolver: AppContainer.shared.container)
                .environment(\.injected, AppContainer.shared.container)
        }
    }
}
