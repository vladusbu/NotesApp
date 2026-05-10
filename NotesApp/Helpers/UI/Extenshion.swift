//
//  Extenshion+UIColor.swift
//  NotesApp
//
//  Created by Vlad on 02.05.2026.
//



import UIKit
import CoreData


extension UIColor {
    
   static func getColor(_ red: CGFloat , _ green: CGFloat , _ blue: CGFloat , _ alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension Date {
    
    func timeAgo() -> String {
        let seconds = Int(Date().timeIntervalSince(self))
        
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        
        if minutes < 1 {
            return "только что"
        } else if minutes < 60 {
            return "\(minutes)"
        } else if hours < 24 {
            return "\(hours)"
        } else if days < 7 {
            return "\(days)"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            return formatter.string(from: self)
        }
    }
}



