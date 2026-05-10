//
//  MockCoreDataStorage.swift
//  NotesApp
//
//  Created by Vlad on 02.05.2026.
//

import Foundation

class MockStorage: NoteStorageProtocol {
    
    static let shared = MockStorage()
    
    private init() {
        notes = [
            
            Note(
                id: UUID(), title: "Список покупок",
                description: "Молоко, хлеб, яйца, сливочное масло,\nсыр пармезан, помидоры черри", pinImage: "thumbtacks 1", date: Date()
            ),
            Note(
                id: UUID(), title: "Идеи для проекта",
                description: "Сделать приложение заметок, добавить теги,\nреализовать поиск и синхронизацию через iCloud", pinImage: "thumbtacks 1" , date: Date()
            ),
            Note(
                id: UUID(), title: "Планы на неделю",
                description: "Понедельник — спортзал , Среда — встреча\nПятница — работа над проектом , Выходные — отдых", pinImage: "" , date: Date()
            )
        
    ]
    }
    
    private var notes: [Note] = []
    
    func saveNotes(_ title: String , _ description: String , _ date: Date , _ pinImage: String) {
        let newNote = Note(id: UUID(), title: title, description: description, pinImage: pinImage, date: date)
        notes.append(newNote)
        print("Заметка Добавлена: \(newNote.title)")
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        print("Заметка Удалена")
    }
    
    func updateNotes(note: Note , title: String, text: String , _ date: Date , _ pinImage: String) {
        print("Update method: \(note.description)")
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        print("index true ")
        notes[index] = Note(
            id: note.id,
            title: title,
            description: text,
            pinImage: pinImage,
            date: date
        )
        
        print(notes[index] )
    }
    
    func getNotes() -> [Note] {
        return notes
    }
}
