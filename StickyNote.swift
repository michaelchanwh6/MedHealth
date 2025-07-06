import Foundation
import SwiftUI

struct StickyNote: Identifiable, Codable {
    let id = UUID()
    var content: String
    var author: String
    var colorName: String  // Changed from Color to String for Codable
    var timestamp: Date
    
    // Computed property to convert colorName to Color
    var color: Color {
        switch colorName {
        case "teal": return .teal
        case "mint": return .mint
        case "yellow": return .yellow
        case "orange": return .orange
        case "pink": return .pink
        default: return .teal
        }
    }
    
    init(content: String, author: String, color: Color, timestamp: Date = Date()) {
        self.content = content
        self.author = author
        self.timestamp = timestamp
        
        // Convert Color to string
        switch color {
        case .teal: self.colorName = "teal"
        case .mint: self.colorName = "mint"
        case .yellow: self.colorName = "yellow"
        case .orange: self.colorName = "orange"
        case .pink: self.colorName = "pink"
        default: self.colorName = "teal"
        }
    }
}
