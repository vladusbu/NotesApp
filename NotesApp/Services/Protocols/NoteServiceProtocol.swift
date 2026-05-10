//
//  MockNoteService.swift
//  NotesApp
//
//  Created by Vlad on 07.05.2026.
//



import Foundation


protocol NoteServiceProtocol {
    func saveNotes(_ notes: Note)
    func deleteNotes(_ notes: Note)
    func updateNotes(note: Note , title: String, text: String , _ date: Date , _ pinImage: String)
    func getNotes() -> [Note]
}
