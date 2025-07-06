import SwiftUI

struct ShiftView: View {
    @Binding var shifts: [Shift]
    @Binding var showConflictAlert: Bool
    @State private var showingAddShift = false
    
    // Current doctor's department (should come from your user data)
    private let doctorDepartment = "Cardiology" // Replace with actual data source
    
    private var filteredShifts: [Shift] {
        shifts.filter { $0.department == doctorDepartment }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Header with department
                HStack {
                    Text("My Shifts")
                        .font(Theme.titleFont)
                        .foregroundColor(Theme.secondaryColor)
                    Spacer()
                    Text(doctorDepartment)
                        .font(.subheadline)
                        .padding(6)
                        .background(Capsule().fill(Theme.primaryColor.opacity(0.2)))
                        .foregroundColor(Theme.primaryColor)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Shifts list
                if filteredShifts.isEmpty {
                    emptyStateView
                } else {
                    shiftsList
                }
                
                // Add Shift Button
                Button(action: {
                    showingAddShift.toggle()
                }) {
                    Text("Add Shift")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showingAddShift) {
                    AddShiftView(shifts: $shifts, showConflictAlert: $showConflictAlert, doctorDepartment: doctorDepartment)
                }
            }
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("My Shifts")
            .alert(isPresented: $showConflictAlert) {
                Alert(
                    title: Text("⚠️ Conflict Detected"),
                    message: Text("The new shift is less than 11 hours apart from an existing shift. Please ensure sufficient rest."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // MARK: - Subviews
    
    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.5))
            Text("No shifts scheduled for \(doctorDepartment)")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Add your first shift using the button below")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.7))
        }
        .frame(maxHeight: .infinity)
    }
    
    private var shiftsList: some View {
        List {
            ForEach(filteredShifts) { shift in
                VStack(alignment: .leading) {
                    Text("\(shift.startDate.formatted(date: .abbreviated, time: .shortened)) - \(shift.endDate.formatted(date: .abbreviated, time: .shortened))")
                        .font(.body)
                    Text("Duration: \(hoursBetween(start: shift.startDate, end: shift.endDate)) hours")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        shifts.removeAll { $0.id == shift.id }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func hoursBetween(start: Date, end: Date) -> Int {
        Int(end.timeIntervalSince(start) / 3600)
    }
}
