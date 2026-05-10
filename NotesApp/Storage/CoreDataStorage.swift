//
//  CoreDataStorage.swift
//  NotesApp
//
//  Created by Vlad on 02.05.2026.
//



import Foundation
import CoreData

enum NotesSeedData {
    static let notes: [Note] = [
        
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

class CoreDataStorage: NoteStorageProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func seedIfNeeded() {
        
        let alreadySeeded = UserDefaults.standard.bool(forKey: "dataSeed")
        guard !alreadySeeded else {return}
        
        NotesSeedData.notes.forEach {saveNotes($0.title, $0.description, $0.date ?? Date(), $0.pinImage ?? "")}
        
        UserDefaults.standard.set(true, forKey: "dataSeed")
    }
    
    func saveNotes(_ title: String, _ description: String, _ date: Date, _ pinImage: String) {
        
        let newNote = NoteEntity(context: context)
        newNote.id = UUID()
        newNote.title = title
        newNote.text = description
        newNote.date = date
        newNote.pinImage = pinImage
        
        do {
            try context.save()
            print("Сохранена заметка: \(newNote.title ?? "")")
        } catch {
            print("Delete error:", error)
        }
        
    }
    
    func deleteNote(_ note: Note) {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)

        if let result = try? context.fetch(request), let object = result.first {
            context.delete(object)

            do {
                try context.save()
                print("Удалена заметка: \(object.title ?? "")")
            } catch {
                print("Delete error:", error)
            }
        }
    }
    
    func updateNotes(note: Note, title: String, text: String, _ date: Date, _ pinImage: String) {

        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)

        do {
            guard let entity = try context.fetch(request).first else {
                print("⚠️ Note not found for update")
                return
            }

            entity.title = title
            entity.text = text
            entity.date = date
            entity.pinImage = pinImage

            try context.save()

            print("Заметка обновлена: \(entity.text ?? "")")

        } catch {
            print("❌ Update error:", error)
        }
    }
    
    func getNotes() -> [Note] {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        guard let result = try? context.fetch(request) else { return [] }
        
       
        let notes: [Note] = result.map {
            Note(
                id: $0.id ?? UUID(), 
                title: $0.title ?? "",
                description: $0.text ?? "",
                pinImage: $0.pinImage,
                date: $0.date
            )
        }
        
        for i in notes {
            print(i.description)
        }
        
        return notes
    }

    
    
}
