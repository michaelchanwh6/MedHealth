import SwiftUI

struct StickyNotesView: View {
    @State private var notes: [StickyNote] = [
        StickyNote(content: "Took a 15 mins walk today. Feeling good!!",
                  author: "Dr. Chen",
                  color: .teal),
        StickyNote(content: "New research: 5-min mindfulness reduces burnout",
                  author: "Dr. Rodriguez",
                  color: .mint),
        StickyNote(content: "Went for a 10km run. Let's get the shift started!!!",
                  author: "Nurse Patel",
                  color: .yellow)
    ]
    
    @State private var newNote = ""
    @State private var selectedColor: Color = .teal
    private let availableColors: [Color] = [.teal, .mint, .yellow, .orange, .pink]
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading) {
                        Text("Community Wisdom")
                            .font(Theme.titleFont)
                            .foregroundColor(Theme.secondaryColor)
                        Text("Share tips with colleagues")
                            .font(Theme.bodyFont)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Notes Grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 20)], spacing: 20) {
                            ForEach(notes) { note in
                                StickyNoteCard(note: note)
                                    .rotationEffect(.degrees(Double.random(in: -3...3)))
                            }
                        }
                        .padding()
                    }
                    
                    // Input Area
                    VStack(spacing: 15) {
                        ColorPickerView(selectedColor: $selectedColor, availableColors: availableColors)
                        
                        TextField("✍️ Share your tip...", text: $newNote)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Theme.bodyFont)
                        
                        Button(action: postNote) {
                            Label("Post Note", systemImage: "note.text.badge.plus")
                                .font(Theme.buttonFont)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.primaryColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(newNote.isEmpty)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 3)
                    )
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Community Board")
        }
    }
    
    private func postNote() {
        guard !newNote.isEmpty else { return }
        withAnimation {
            let note = StickyNote(
                content: newNote,
                author: "Dr. Smith",
                color: selectedColor
            )
            notes.insert(note, at: 0)
            newNote = ""
        }
    }
}

// MARK: - Subviews
struct StickyNoteCard: View {
    let note: StickyNote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.content)
                .font(Theme.bodyFont)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            HStack {
                Text("👤 \(note.author)")
                    .font(.caption)
                Spacer()
                Text(note.timestamp.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
            }
            .foregroundColor(.black.opacity(0.7))
        }
        .padding()
        .frame(minHeight: 120, alignment: .topLeading)
        .background(note.color.opacity(0.9))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    let availableColors: [Color]
    
    var body: some View {
        HStack {
            ForEach(availableColors, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle()
                            .stroke(selectedColor == color ? Theme.primaryColor : Color.clear, lineWidth: 3)
                    )
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}
