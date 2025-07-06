import SwiftUI

struct TradeManagementView: View {
    @State private var myShifts: [Shift] = [
        Shift(startDate: Date().addingTimeInterval(3600 * 24), endDate: Date().addingTimeInterval(3600 * 32), department: "Cardiology"),
        Shift(startDate: Date().addingTimeInterval(3600 * 48), endDate: Date().addingTimeInterval(3600 * 56), department: "Neurology")
    ]
    
    @State private var availableShifts: [Shift] = [
        Shift(startDate: Date().addingTimeInterval(3600 * 24 * 3), endDate: Date().addingTimeInterval(3600 * 24 * 4), department: "Orthopedics"),
        Shift(startDate: Date().addingTimeInterval(3600 * 24 * 5), endDate: Date().addingTimeInterval(3600 * 24 * 6), department: "Gastroenterology")
    ]
    
    @State private var tradeRequests: [TradeRequest] = []
    @State private var selectedMyShift: Shift?
    @State private var selectedAvailableShift: Shift?
    
    var body: some View {
        NavigationView {
            VStack {
                // Section: Offer your shift for trade
                Text("Your Shifts")
                    .font(.headline)
                
                List {
                    ForEach(myShifts) { shift in
                        HStack {
                            Text("\(shift.startDate.formatted()) - \(shift.endDate.formatted())")
                                .onTapGesture {
                                    selectedMyShift = shift
                                }
                            if selectedMyShift?.id == shift.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                
                Button("Offer Selected Shift for Trade") {
                    if let shift = selectedMyShift {
                        let request = TradeRequest(
                            originalShift: shift,
                            requestedShift: nil,
                            status: "Pending",
                            isIncoming: false,
                            senderID: "You" // Added senderID here
                        )
                        tradeRequests.append(request)
                        myShifts.removeAll { $0.id == shift.id }
                    }
                }
                .padding()
                
                Divider()
                
                // Section: Shifts open for trade
                Text("Available Shifts for Trade")
                    .font(.headline)
                
                List {
                    ForEach(availableShifts) { shift in
                        HStack {
                            Text("\(shift.startDate.formatted()) - \(shift.endDate.formatted())")
                                .onTapGesture {
                                    selectedAvailableShift = shift
                                }
                            if selectedAvailableShift?.id == shift.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                
                Button("Request Trade for Selected Shift") {
                    if let shift = selectedAvailableShift {
                        let request = TradeRequest(
                            originalShift: shift,
                            requestedShift: selectedMyShift,
                            status: "Pending",
                            isIncoming: true,
                            senderID: "You" // Added senderID here
                        )
                        tradeRequests.append(request)
                        availableShifts.removeAll { $0.id == shift.id }
                    }
                }
                .padding()
                
                Spacer()
                
                // Incoming trade requests
                Text("Incoming Trade Requests")
                    .font(.headline)
                
                List {
                    ForEach(tradeRequests.filter { $0.isIncoming && $0.status == "Pending" }) { request in
                        VStack(alignment: .leading) {
                            Text("Trade request from \(request.senderID)")
                                .font(.subheadline)
                            Text("Shift: \(request.originalShift.startDate.formatted())")
                            HStack {
                                Button("Accept") {
                                    acceptTrade(request: request)
                                }
                                Button("Decline") {
                                    declineTrade(request: request)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Trade Management")
            .onAppear {
                loadSampleData()
            }
        }
    }
    
    func loadSampleData() {
        // Sample data remains unchanged
    }
    
    func acceptTrade(request: TradeRequest) {
        if let index = tradeRequests.firstIndex(where: { $0.id == request.id }) {
            tradeRequests[index].status = "Accepted"
            myShifts.append(request.originalShift)
            
            if let offeredShift = request.requestedShift {
                myShifts.removeAll { $0.id == offeredShift.id }
            }
        }
    }
    
    func declineTrade(request: TradeRequest) {
        if let index = tradeRequests.firstIndex(where: { $0.id == request.id }) {
            tradeRequests[index].status = "Declined"
            availableShifts.append(request.originalShift)
        }
    }
}
