import SwiftUI

struct ContentView: View {
    @State private var shifts: [Shift] = [
        Shift(startDate: Date().addingTimeInterval(3600 * 24), endDate: Date().addingTimeInterval(3600 * 32), department: "Cardiology"),
        Shift(startDate: Date().addingTimeInterval(3600 * 48), endDate: Date().addingTimeInterval(3600 * 56), department: "Neurology")
    ]
    @State private var showConflictAlert = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Welcome Back, Dr. Smith")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.secondaryColor)
                        .padding(.top, 40)
                        .multilineTextAlignment(.center)
                    
                    Text("Manage your schedule, trade shifts, and support your well-being.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // My Shifts Button
                    NavigationLink(destination: ShiftView(shifts: $shifts, showConflictAlert: $showConflictAlert)) {
                        Label("My Shifts", systemImage: "calendar")
                            .font(Theme.buttonFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // Trade Shifts Button
                    NavigationLink(destination: TradeShiftView(myShifts: $shifts)) {
                        Label("Trade Shifts", systemImage: "arrow.triangle.2.circlepath")
                            .font(Theme.buttonFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.secondaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // Health Tips Button
                    NavigationLink(destination: TipsView()) {
                        Label("Health Tips", systemImage: "lightbulb")
                            .font(Theme.buttonFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // Community Button
                    NavigationLink(destination: StickyNotesView()) {
                        Label("Community", systemImage: "note.text")
                            .font(Theme.buttonFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.purpleAccent)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // Profile Button
                    NavigationLink(destination: ProfileView()) {
                        Label("My Profile", systemImage: "person.crop.circle")
                            .font(Theme.buttonFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
}
