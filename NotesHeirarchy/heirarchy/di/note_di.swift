//
//  note_di.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//
import Swinject
import AppCore


public final class NoteAssembly: Assembly {
    public init(){}
    
    public func assemble(container: Container){
        //MARK: - Network Layer
        
        container.register(NoteRemoteSource.self) { r in
            NoteRemoteSourceImpl(apiClient: r.resolve(APIClient.self)!)
        }
        
        container.register(NoteRepository.self) { r in
            NoteRepositoryImpl(noteRemoteSource: r.resolve(NoteRemoteSource.self)!)
        }
        // MARK: - Use Cases
        
        container.register(AddUserNoteUseCase.self) { r in
            AddUserNoteUseCase(noteRepository: r.resolve(NoteRepository.self)!)
        }
        
        container.register(GetNotesUseCase.self) { r in
            GetNotesUseCase(noteRepository: r.resolve(NoteRepository.self)!)
        }
        
        container.register(UpdateUserNoteUseCase.self) { r in
            UpdateUserNoteUseCase(noteRepository: r.resolve(NoteRepository.self)!)
        }
        
        container.register(GetSpecificNoteUseCase.self) { r in
            GetSpecificNoteUseCase(noteRepository: r.resolve(NoteRepository.self)!)
        }
        
        container.register(GetUserNoteUseCase.self) { r in
            GetUserNoteUseCase(noteRepository: r.resolve(NoteRepository.self)!)
        }
        
        container.register(RemoveUserNoteUseCase.self) { r in
            RemoveUserNoteUseCase(noteRepository: r.resolve(NoteRepository.self)!)
        }
        
        container.register(RemoveUserNoteUseCase.self) { r in
            RemoveUserNoteUseCase(noteRepository: r.resolve(NoteRepository.self)!)
        }
        
        // MARK: viewModels
        container.register(NoteListViewModel.self){ r in
            NoteListViewModel(
                _getNoteListUseCase: r.resolve( GetNotesUseCase.self)!,
                _deleteSpecificUser: r.resolve(RemoveUserNoteUseCase.self)!,
                _appEnvironment: r.resolve(AppEnvironment.self)!
            )
        }

        
        container.register(UserNoteListViewModel.self){ r  in
            UserNoteListViewModel(
                _getUserNoteListUseCase: r.resolve(GetUserNoteUseCase.self)!,
                _deleteSpecificUser: r.resolve(RemoveUserNoteUseCase.self)!,
                appEnvironment: r.resolve(AppEnvironment.self)!
            )
        }
        
        container.register(NoteDetailViewModel.self){ (r,noteId) in
            NoteDetailViewModel(
                _getSpecificNoteUseCase: r.resolve(GetSpecificNoteUseCase.self)!,
                _removeUserNoteUseCase: r.resolve(RemoveUserNoteUseCase.self)!,
                _updateNoteUseCase: r.resolve(UpdateUserNoteUseCase.self)!, noteId: noteId)
        }
    }
}
