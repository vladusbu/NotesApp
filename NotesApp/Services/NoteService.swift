//
//  NoteService.swift
//  NotesApp
//
//  Created by Vlad on 02.05.2026.
//



import Foundation


class NoteService: NoteServiceProtocol {
    
    let storage: NoteStorageProtocol
    
    init(storage: NoteStorageProtocol) {
        self.storage = storage
    }
    
    
    func deleteNotes(_ notes: Note) {
        storage.deleteNote(notes)
    }
    
    func getNotes() -> [Note] {
        return storage.getNotes() 
    }
    
    func saveNotes(_ notes: Note) {
        storage.saveNotes(notes.title, notes.description, notes.date ?? Date(), notes.pinImage ?? "")
    }
    
    func updateNotes(note: Note, title: String, text: String, _ date: Date, _ pinImage: String) {
        storage.updateNotes(note: note, title: title, text: text, date , pinImage)
    }
}



