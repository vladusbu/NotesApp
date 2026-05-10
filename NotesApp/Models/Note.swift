//
//  Note.swift
//  NotesApp
//
//  Created by Vlad on 02.05.2026.
//



import Foundation


struct Note: Equatable {
    let id: UUID
    let title: String
    let description: String
    let pinImage: String?
    let date: Date?
}
