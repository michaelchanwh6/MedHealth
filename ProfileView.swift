import SwiftUI
import Charts

struct ProfileView: View {
    // Basic Profile Info
    @State private var doctorName = "Dr. Jane Smith"
    @State private var doctorSpecialty = "Cardiologist"
    
    // Work Data Sample (30 days)
    @State private var monthlyStats: [WorkData] = generateSampleData()
    
    // Computed Properties
    private var totalWorkHours: Int {
        Int(monthlyStats.reduce(0) { $0 + $1.workHours })
    }
    
    private var totalOffHours: Int {
        Int(monthlyStats.reduce(0) { $0 + $1.offHours })
    }
    
    private var workIndex: Double {
        guard totalOffHours > 0 else { return 0 }
        return Double(totalWorkHours) / Double(totalOffHours)
    }
    
    private var workIndexStatus: (color: Color, message: String, icon: String) {
        switch workIndex {
        case ..<1.0:
            return (.green, "Excellent work-life balance", "face.smiling")
        case 1.0..<1.4:
            return (.orange, "Needs more rest", "exclamationmark.triangle")
        default:
            return (.red, "High burnout risk!", "flame")
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    profileHeader
                    
                    // Health Status Card
                    healthStatusCard
                    
                    // Stats Cards
                    HStack(spacing: 15) {
                        StatCard(
                            value: "\(totalWorkHours)h",
                            label: "Monthly Work",
                            icon: "clock.fill",
                            gradient: [Theme.primaryColor, Theme.accentColor]
                        )
                        
                        StatCard(
                            value: "\(totalOffHours)h",
                            label: "Monthly Rest",
                            icon: "bed.double.fill",
                            gradient: [Theme.purpleAccent, Theme.secondaryColor]
                        )
                    }
                    .padding(.horizontal)
                    
                    // Work Hours Chart
                    workHoursChart
                    
                    // Recommendations
                    recommendationsSection
                }
                .padding(.bottom, 30)
            }
            .background(appBackground)
            .navigationTitle("My Profile")
        }
    }
    
    // MARK: - Subviews
    
    private var profileHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(profileIconGradient)
            
            VStack(spacing: 4) {
                Text(doctorName)
                    .font(.title.bold())
                Text(doctorSpecialty)
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 20)
    }
    
    private var healthStatusCard: some View {
        HStack {
            Image(systemName: workIndexStatus.icon)
                .font(.title)
                .foregroundColor(workIndexStatus.color)
            
            VStack(alignment: .leading) {
                Text("Work-Life Balance")
                    .font(.headline)
                Text(workIndexStatus.message)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Text(String(format: "Index: %.1f", workIndex))
                .font(.title3.monospacedDigit().bold())
                .foregroundColor(workIndexStatus.color)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(workIndexStatus.color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(workIndexStatus.color, lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
    
    private var workHoursChart: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("WORK HOURS ANALYSIS")
                .font(.caption)
                .foregroundColor(.gray)
            
            Chart(monthlyStats) { data in
                BarMark(
                    x: .value("Day", data.day),
                    y: .value("Work Hours", data.workHours),
                    width: .fixed(12)
                )
                .foregroundStyle(workHoursGradient)
                
                BarMark(
                    x: .value("Day", data.day),
                    y: .value("Off Hours", data.offHours),
                    width: .fixed(12)
                )
                .foregroundStyle(offHoursGradient)
            }
            .chartYAxis { AxisMarks(position: .leading) }
            .frame(height: 250)
            .padding(.vertical, 10)
        }
        .padding()
        .background(chartBackground)
        .padding(.horizontal)
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("RECOMMENDATIONS")
                .font(.caption)
                .foregroundColor(.gray)
            
            ForEach(recommendations, id: \.self) { recommendation in
                HStack(alignment: .top) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .padding(.top, 6)
                    Text(recommendation)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(recommendationsBackground)
        .padding(.horizontal)
    }
    
    private var recommendations: [String] {
        switch workIndex {
        case ..<1.0:
            return [
                "Maintain your current schedule",
                "Consider mentoring colleagues",
                "Keep up your healthy habits"
            ]
        case 1.0..<1.4:
            return [
                "Schedule at least 1 extra rest day this month",
                "Delegate non-critical tasks when possible",
                "Practice 10-min mindfulness daily"
            ]
        default:
            return [
                "Immediately reduce workload by 20%",
                "Schedule a meeting with your supervisor",
                "Consider professional counseling",
                "Mandatory 2 consecutive days off"
            ]
        }
    }
    
    // MARK: - Style Components
    private var profileIconGradient: LinearGradient {
        LinearGradient(
            colors: [Theme.primaryColor, Theme.secondaryColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var workHoursGradient: LinearGradient {
        LinearGradient(
            colors: [Theme.primaryColor.opacity(0.8), Theme.accentColor],
            startPoint: .bottom,
            endPoint: .top
        )
    }
    
    private var offHoursGradient: LinearGradient {
        LinearGradient(
            colors: [Color.green.opacity(0.3), Color.green.opacity(0.6)],
            startPoint: .bottom,
            endPoint: .top
        )
    }
    
    private var chartBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var recommendationsBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var appBackground: some View {
        LinearGradient(
            colors: [Theme.backgroundColor, Color(.systemBackground)],
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - StatCard View (previously missing)
struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.body.bold())
                Text(value)
                    .font(.title2.bold())
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(0.2)
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
    }
}

// Helper function for sample data
private func generateSampleData() -> [WorkData] {
    var stats = [WorkData]()
    for day in 1...30 {
        stats.append(WorkData(
            day: day,
            workHours: Double.random(in: 6...16),
            offHours: 24 - Double.random(in: 6...16))
        )
    }
    return stats
}

// Data Model
struct WorkData: Identifiable {
    let id = UUID()
    let day: Int
    let workHours: Double
    let offHours: Double
}
