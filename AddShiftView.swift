import SwiftUI

struct AddShiftView: View {
    @Binding var shifts: [Shift]
    @Binding var showConflictAlert: Bool
    var doctorDepartment: String  // Changed to var and non-private
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Shift Details")) {
                    DatePicker("Start Time", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End Time", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                    
                    // Display department (non-editable)
                    HStack {
                        Text("Department")
                        Spacer()
                        Text(doctorDepartment)
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Button("Add Shift") {
                        let newShift = Shift(
                            startDate: startDate,
                            endDate: endDate,
                            department: doctorDepartment  // Using the passed department
                        )
                        
                        if hasConflict(newShift: newShift) {
                            showConflictAlert = true
                        } else {
                            shifts.append(newShift)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(startDate >= endDate)
                }
            }
            .navigationTitle("Add New Shift")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func hasConflict(newShift: Shift) -> Bool {
        for shift in shifts {
            let timeBetween = Calendar.current.dateComponents([.hour], from: shift.endDate, to: newShift.startDate).hour ?? 0
            if abs(timeBetween) < 11 {
                return true
            }
        }
        return false
    }
}
