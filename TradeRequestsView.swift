import SwiftUI

struct TradeRequestsView: View {
    @Binding var tradeRequests: [TradeRequest]
    @Binding var myShifts: [Shift]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach($tradeRequests) { $request in
                    if request.isIncoming && request.status == "Pending" {
                        VStack(alignment: .leading) {
                            // Department verification badge
                            HStack {
                                if let requestedDept = request.requestedShift?.department,
                                   request.originalShift.department == requestedDept {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.green)
                                    Text("Same Department")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            
                            // Existing request content...
                            if let requestedShift = request.requestedShift {
                                Text("Your \(requestedShift.department) Shift:")
                                Text(requestedShift.startDate.formatted())
                            }
                            
                            Text("Offered \(request.originalShift.department) Shift:")
                            Text(request.originalShift.startDate.formatted())
                            
                            HStack {
                                Button("Accept") {
                                    if let requestedShift = request.requestedShift,
                                       requestedShift.department == request.originalShift.department {
                                        acceptTrade(request: &request)
                                    }
                                }
                                
                                Button("Decline") {
                                    request.status = "Declined"
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("Trade Requests")
    }
    
    private func acceptTrade(request: inout TradeRequest) {
        // Add the new shift
        myShifts.append(request.originalShift)
        
        // Remove the traded shift if specified
        if let shiftToRemove = request.requestedShift {
            myShifts.removeAll { $0.id == shiftToRemove.id }
        }
        
        // Update request status
        request.status = "Accepted"
    }
}
