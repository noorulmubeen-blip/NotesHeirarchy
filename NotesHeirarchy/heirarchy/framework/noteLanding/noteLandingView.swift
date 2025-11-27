//
//  noteLandingView.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 24/11/2025.
//
import SwiftUI
import Swinject

struct NoteLandingView : View {
    @Environment(\.injected) private var resolver : Resolver
    
    init(resolver: Resolver) {
    }
    var body : some View{
        TabView {
            NoteListView(resolver: resolver)
                        .tabItem {
                            Label("Notes List", systemImage: "list.dash")
                        }

            UserNoteListView(resolver : resolver)
                        .tabItem {
                            Label("User Note List view", systemImage: "square.and.pencil")
                        }
                }
    }
}
