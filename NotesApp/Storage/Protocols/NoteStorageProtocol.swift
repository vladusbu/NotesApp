//
//  MockStorageProtocol.swift
//  NotesApp
//
//  Created by Vlad on 02.05.2026.
//



import Foundation


protocol NoteStorageProtocol {
    func saveNotes(_ title: String , _ description: String , _ date: Date , _ pinImage: String)
    func deleteNote(_ note: Note)
    func updateNotes(note: Note , title: String, text: String , _ date: Date , _ pinImage: String)
    func getNotes() -> [Note]
}




extension NoteStorageProtocol {
    func seedIfNeeded() { }
}
