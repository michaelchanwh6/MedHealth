import SwiftUI

struct TradeShiftView: View {
    @Binding var myShifts: [Shift]
    @State private var availableShifts: [Shift] = []
    @State private var tradeRequests: [TradeRequest] = []
    @State private var selectedMyShift: Shift?
    @State private var selectedAvailableShift: Shift?
    @State private var showingRequests = false
    
    // Current doctor's department (replace with your actual data source)
    private let currentDoctorDepartment = "Cardiology" // Example
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Requests Inbox Button
                requestsInboxButton
                
                // Available Shifts (same department only)
                SectionHeader(title: "Available Shifts (\(currentDoctorDepartment))")
                
                if availableShifts.isEmpty {
                    Text("No available shifts in your department")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    availableShiftsList
                }
                
                // Your Shifts
                SectionHeader(title: "Your Shifts (\(currentDoctorDepartment))")
                yourShiftsList
                
                // Trade Action Section
                tradeActionSection
            }
            .padding(.top)
        }
        .navigationTitle("Trade Shifts")
        .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
        .onAppear {
            loadSampleData()
        }
    }
    
    // MARK: - Subviews
    
    private var requestsInboxButton: some View {
        Button(action: { showingRequests.toggle() }) {
            HStack {
                Image(systemName: "envelope.fill")
                Text("Trade Requests (\(tradeRequests.filter { $0.isIncoming && $0.status == "Pending" }.count))")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.purpleAccent)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingRequests) {
            TradeRequestsView(tradeRequests: $tradeRequests, myShifts: $myShifts)
        }
    }
    
    private var availableShiftsList: some View {
        ForEach(availableShifts) { shift in
            ShiftCardView(
                shift: shift,
                isSelected: selectedAvailableShift?.id == shift.id,
                department: shift.department
            ) {
                selectedAvailableShift = shift
            }
            .padding(.horizontal)
        }
    }
    
    private var yourShiftsList: some View {
        ForEach(myShifts.filter { $0.department == currentDoctorDepartment }) { shift in
            ShiftCardView(
                shift: shift,
                isSelected: selectedMyShift?.id == shift.id,
                department: shift.department
            ) {
                selectedMyShift = shift
            }
            .padding(.horizontal)
        }
    }
    
    private var tradeActionSection: some View {
        Group {
            if let myShift = selectedMyShift, let availableShift = selectedAvailableShift {
                Button(action: createTradeRequest) {
                    Text("Send Trade Request")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            } else {
                Text("Select one of your shifts and an available \(currentDoctorDepartment) shift to propose a trade.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Data Loading
    
    private func loadSampleData() {
        // Only load shifts from the same department
        availableShifts = [
            Shift(startDate: Date().addingTimeInterval(3600 * 24 * 3),
            endDate: Date().addingTimeInterval(3600 * 24 * 4),
            department: currentDoctorDepartment),
            
            Shift(startDate: Date().addingTimeInterval(3600 * 24 * 5),
            endDate: Date().addingTimeInterval(3600 * 24 * 6),
            department: currentDoctorDepartment),
            
            Shift(startDate: Date().addingTimeInterval(3600 * 24 * 7),
            endDate: Date().addingTimeInterval(3600 * 24 * 8),
            department: currentDoctorDepartment)
        ]
        
        // Sample incoming requests (same department only)
        tradeRequests = [
            TradeRequest(
                originalShift: Shift(startDate: Date().addingTimeInterval(3600 * 24 * 2),
                endDate: Date().addingTimeInterval(3600 * 24 * 3),
                department: currentDoctorDepartment),
                requestedShift: myShifts.first(where: { $0.department == currentDoctorDepartment }),
                status: "Pending",
                isIncoming: true,
                senderID: "Dr. Chen"
            )
        ]
    }
    
    // MARK: - Trade Logic
    
    private func createTradeRequest() {
        guard let myShift = selectedMyShift,
              let availableShift = selectedAvailableShift else { return }
        
        let request = TradeRequest(
            originalShift: availableShift,
            requestedShift: myShift,
            status: "Pending",
            isIncoming: false,
            senderID: "You" // Current user
        )
        
        tradeRequests.append(request)
        availableShifts.removeAll { $0.id == availableShift.id }
        myShifts.removeAll { $0.id == myShift.id }
        selectedMyShift = nil
        selectedAvailableShift = nil
    }
}

// MARK: - Supporting Views (same as before)
struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(Theme.titleFont)
            .foregroundColor(Theme.secondaryColor)
            .padding(.horizontal)
    }
}

struct ShiftCardView: View {
    let shift: Shift
    let isSelected: Bool
    let department: String
    let action: () -> Void
    
    var body: some View {
        CardView {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(shift.startDate.formatted(date: .abbreviated, time: .shortened))")
                    Text("Dept: \(department)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(10)
            .onTapGesture(perform: action)
        }
    }
}
