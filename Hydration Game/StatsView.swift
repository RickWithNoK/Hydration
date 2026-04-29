import SwiftUI
import SwiftData
import Charts

/// Displays a read-only summary of the user's hydration stats:
/// current intake, daily goal, streak history, hydra boost multiplier,
/// the last-updated timestamp, a 7-day intake bar chart, rolling average,
/// and all-time total water consumed.
struct StatsView: View {
    @Query var waterData: [WaterData]

    /// The last 7 days of intake plus today, shaped for the chart.
    var chartData: [(label: String, amount: Int)] {
        guard let data = waterData.first else { return [] }

        // weeklyHistory holds past days (up to 7); append today's live value
        let history = data.weeklyHistory + [data.totalWater]
        let days = history.suffix(7)

        let calendar = Calendar.current
        let today = Date()

        return days.enumerated().map { index, amount in
            let offset = -(days.count - 1 - index)
            let date = calendar.date(byAdding: .day, value: offset, to: today) ?? today
            let label = offset == 0 ? "Today" : date.formatted(.dateTime.weekday(.abbreviated))
            return (label: label, amount: amount)
        }
    }

    /// Rolling average of the days shown in the chart.
    var averageIntake: Int {
        guard !chartData.isEmpty else { return 0 }
        let total = chartData.reduce(0) { $0 + $1.amount }
        return total / chartData.count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let data = waterData.first {
                    Text("Stats")
                        .font(.largeTitle)
                        .bold()

                    // MARK: Today
                    GroupBox("Today") {
                        VStack(alignment: .leading, spacing: 8) {
                            statRow(label: "Water logged", value: "\(data.totalWater) ml")
                            statRow(label: "Daily goal", value: "\(data.dailyGoal) ml")
                            statRow(label: "Progress", value: "\(Int(min(Double(data.totalWater) / Double(data.dailyGoal), 1.0) * 100))%")
                        }
                    }

                    // MARK: Streaks
                    GroupBox("Streaks") {
                        VStack(alignment: .leading, spacing: 8) {
                            statRow(label: "🔥 Current streak", value: "\(data.streak) days")
                            statRow(label: "🏆 Best streak", value: "\(data.bestStreak) days")
                            statRow(label: "💜 Hydra boost", value: streakBoostText(for: data.streak))
                        }
                    }

                    // MARK: Weekly Chart
                    if !chartData.isEmpty {
                        GroupBox("Last 7 Days") {
                            Chart(chartData, id: \.label) { entry in
                                BarMark(
                                    x: .value("Day", entry.label),
                                    y: .value("ml", entry.amount)
                                )
                                .foregroundStyle(entry.label == "Today" ? Color.blue : Color.teal)
                                .cornerRadius(4)

                                RuleMark(y: .value("Goal", data.dailyGoal))
                                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                                    .foregroundStyle(.green)
                                    .annotation(position: .trailing) {
                                        Text("Goal")
                                            .font(.caption2)
                                            .foregroundStyle(.green)
                                    }
                            }
                            .frame(height: 180)
                            .padding(.top, 8)
                        }
                    }

                    // MARK: Averages & All-Time
                    GroupBox("All-Time") {
                        VStack(alignment: .leading, spacing: 8) {
                            statRow(label: "7-day average", value: "\(averageIntake) ml / day")
                            statRow(label: "Total ever logged", value: "\(data.totalWaterAllTime) ml")
                        }
                    }

                    // MARK: Last Updated
                    Text("Last updated: \(data.lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                } else {
                    Text("No hydration data yet.")
                        .font(.headline)
                }
            }
            .padding()
        }
    }

    /// A simple two-column label/value row used inside `GroupBox` sections.
    @ViewBuilder
    func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
        .font(.subheadline)
    }

    /// Formats the streak boost multiplier as a string (e.g. "1.2x").
    /// Uses integer division by 3 so the boost steps up every third streak day.
    func streakBoostText(for streak: Int) -> String {
        let boost = 1.0 + (Double(streak / 3) * 0.1)
        return String(format: "%.1fx", boost)
    }
}

#Preview {
    StatsView()
        .modelContainer(for: WaterData.self, inMemory: true)
}

