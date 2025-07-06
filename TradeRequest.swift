import Foundation

struct TradeRequest: Identifiable {
    let id = UUID()
    var originalShift: Shift  // Shift you're receiving
    var requestedShift: Shift? // Shift you're giving away
    var status: String
    var isIncoming: Bool
    var senderID: String
}
