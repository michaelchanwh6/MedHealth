//
//  TipsView.swift
//  doctorhealth
//
//  Created by Gigi on 2025-07-05.
//
import SwiftUI
import SwiftUI

struct TipsView: View {
    let tipCategories = [
        TipCategory(
            title: "⏰ Time Management",
            icon: "clock.fill",
            color: Theme.primaryColor,
            tips: [
                "Block scheduling: Dedicate specific hours to specific tasks",
                "Priority matrix: Categorize tasks by urgency/importance",
                "Pomodoro technique: Work in focused 25-min intervals"
            ]
        ),
        TipCategory(
            title: "🧠 Mental Health",
            icon: "brain.head.profile",
            color: Theme.secondaryColor,
            tips: [
                "Daily mindfulness: 5-min morning meditation",
                "Peer support groups: Connect with colleagues weekly",
                "Digital detox: 1 hour screen-free before bed"
            ]
        ),
        TipCategory(
            title: "💪 Stress Relief",
            icon: "heart.fill",
            color: Theme.accentColor,
            tips: [
                "Box breathing: Inhale 4s, hold 4s, exhale 4s",
                "Progressive muscle relaxation: Tense/release muscle groups",
                "Nature breaks: 10-min outdoor walks between shifts"
            ]
        ),
        TipCategory(
            title: "🍏 Nutrition",
            icon: "leaf.fill",
            color: Theme.purpleAccent,
            tips: [
                "Hydration: Keep a water bottle at your station",
                "Energy snacks: Nuts, fruits, and yogurt",
                "Meal prep: Prepare healthy meals in advance"
            ]
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HeaderView()
                    
                    ForEach(tipCategories) { category in
                        TipCategoryCard(category: category)
                    }
                    
                    EmergencyResourcesCard()
                }
                .padding()
            }
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("Health Toolkit")
        }
    }
}

// MARK: - Components
struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Clinician Wellness")
                .font(Theme.titleFont)
                .foregroundColor(Theme.secondaryColor)
            
            Text("Evidence-based strategies for healthcare professionals")
                .font(Theme.bodyFont)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }
}

struct TipCategoryCard: View {
    let category: TipCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(category.color)
                    .font(.title2)
                
                Text(category.title)
                    .font(Theme.titleFont)
                    .foregroundColor(Theme.secondaryColor)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(category.tips, id: \.self) { tip in
                    HStack(alignment: .top) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .padding(.top, 6)
                            .foregroundColor(category.color)
                        
                        Text(tip)
                            .font(Theme.bodyFont)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.leading, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct EmergencyResourcesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cross.case.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                
                Text("Emergency Support")
                    .font(Theme.titleFont)
                    .foregroundColor(Theme.secondaryColor)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Link("National Clinician Support Line", destination: URL(string: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8284105/")!)
                Link("Crisis Text Line: Text HOME to 741741", destination: URL(string: "https://www.crisistextline.org/")!)
            }
            .font(Theme.bodyFont)
            .accentColor(Theme.primaryColor)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Models
struct TipCategory: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let tips: [String]
}
