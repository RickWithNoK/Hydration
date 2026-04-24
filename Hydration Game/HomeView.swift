
import SwiftUI
import SwiftData

struct HomeView: View {
    @Query var waterData: [WaterData]
    @Environment(\.modelContext) var context

    let goal = 2000

    var progress: Double {
        guard let data = waterData.first else { return 0.0 }
        return min(Double(data.totalWater) / Double(goal), 1.0)
    }

    var body: some View {
        VStack(spacing: 20) {
            if let data = waterData.first {

                Text("💧 \(data.totalWater) ml")
                    .font(.largeTitle)

                HStack(spacing: 15) {
                    Button("250 ml") {
                        addWater(250, to: data)
                    }

                    Button("500 ml") {
                        addWater(500, to: data)
                    }

                    Button("1000 ml") {
                        addWater(1000, to: data)
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    data.totalWater = 0
                    data.lastUpdated = Date()
                }
                .foregroundStyle(.red)

                ProgressView(value: progress)
                    .tint(progress >= 1.0 ? .green : .blue)
                    .padding()

                Text("\(Int(progress * 100))% of daily goal")
                    .font(.headline)

                if data.totalWater >= goal {
                    Text("🎉 Goal Reached!")
                        .font(.title2)
                        .foregroundStyle(.green)
                }

            } else {
                Text("Loading hydration data...")
                    .font(.headline)
            }
        }
        .padding()
        .onAppear {
            if waterData.isEmpty {
                let newData = WaterData()
                context.insert(newData)
            } else if let data = waterData.first {
                resetIfNewDay(data)
            }
        }
    }

    func addWater(_ amount: Int, to data: WaterData) {
        resetIfNewDay(data)

        let wasBelowGoal = data.totalWater < goal

        data.totalWater += amount
        data.lastUpdated = Date()

        if wasBelowGoal && data.totalWater >= goal {
            updateStreak(for: data)
        }
    }
    func updateStreak(for data: WaterData) {
        let today = Date()

        if let lastGoalDate = data.lastGoalDate {
            if Calendar.current.isDate(lastGoalDate, inSameDayAs: today) {
                return
            }

            if Calendar.current.isDateInYesterday(lastGoalDate) {
                data.streak += 1
            } else {
                data.streak = 1
            }
        } else {
            data.streak = 1
        }

        data.lastGoalDate = today
        data.bestStreak = max(data.bestStreak, data.streak)
    }
    
    func resetIfNewDay(_ data: WaterData) {
        if !Calendar.current.isDate(data.lastUpdated, inSameDayAs: Date()) {
            data.totalWater = 0
            data.lastUpdated = Date()
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: WaterData.self, inMemory: true)
}
