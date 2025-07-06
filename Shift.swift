//
//  Shift.swift
//  doctorhealth
//
//  Created by Gigi on 2025-07-05.
//
import Foundation

struct Shift: Identifiable, Equatable {
    let id = UUID()
    var startDate: Date
    var endDate: Date
    var department: String
    
    static func == (lhs: Shift, rhs: Shift) -> Bool {
        return lhs.id == rhs.id
    }
}
