import SwiftUI
import SwiftData

struct StatsView: View {
    @Query var waterData: [WaterData]

    var body: some View {
        VStack(spacing: 20) {
            if let data = waterData.first {
                Text("Stats")
                    .font(.largeTitle)
                    .bold()

                Text("Current Water: \(data.totalWater) ml")
                    .font(.title3)

                Text("Daily Goal: \(data.dailyGoal) ml")
                    .font(.title3)

                Text("🔥 Current Streak: \(data.streak) days")
                    .font(.title3)

                Text("🏆 Best Streak: \(data.bestStreak) days")
                    .font(.title3)

                Text("Hydra Boost: \(streakBoostText(for: data.streak))")
                    .font(.headline)
                    .foregroundStyle(.purple)

                Text("Last Updated:")
                    .font(.headline)

                Text(data.lastUpdated.formatted(date: .abbreviated, time: .shortened))
                    .font(.body)

            } else {
                Text("No hydration data yet.")
                    .font(.headline)
            }
        }
        .padding()
    }

    func streakBoostText(for streak: Int) -> String {
        let boost = 1.0 + (Double(streak / 3) * 0.1)
        return String(format: "%.1fx", boost)
    }
}

#Preview {
    StatsView()
        .modelContainer(for: WaterData.self, inMemory: true)
}
