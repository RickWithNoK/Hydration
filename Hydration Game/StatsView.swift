import SwiftUI
import SwiftData

struct StatsView: View {
    @Query var waterData: [WaterData]

    let goal = 2000

    var body: some View {
        VStack(spacing: 20) {
            if let data = waterData.first {
                Text("Stats")
                    .font(.largeTitle)
                    .bold()

                Text("Current Water: \(data.totalWater) ml")
                    .font(.title3)

                Text("Daily Goal: \(goal) ml")
                    .font(.title3)

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
}

#Preview {
    StatsView()
        .modelContainer(for: WaterData.self, inMemory: true)
}
