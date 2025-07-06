//
//  doctorhealthApp.swift
//  doctorhealth
//
//  Created by Gigi on 2025-07-05.
//

import SwiftUI

@main
struct doctorhealthApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    let sampleMyShifts = [
        Shift(startDate: Date().addingTimeInterval(3600*24), endDate: Date().addingTimeInterval(3600*32), department: "Cardiology"),
        Shift(startDate: Date().addingTimeInterval(3600*48), endDate: Date().addingTimeInterval(3600*56), department: "Neurology")
    ]

    let sampleAvailableShifts = [
        Shift(startDate: Date().addingTimeInterval(3600*24*3), endDate: Date().addingTimeInterval(3600*24*4), department: "Cardiology"),
        Shift(startDate: Date().addingTimeInterval(3600*24*5), endDate: Date().addingTimeInterval(3600*24*6), department: "Neurology")
    ]
}
