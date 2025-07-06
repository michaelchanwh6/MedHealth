import SwiftUI

struct CardView<Content: View>: View {
    let content: () -> Content
   
    var body: some View {
        VStack {
            content()
        }
        .padding()
        .background(Theme.whiteColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
