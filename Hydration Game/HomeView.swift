
import SwiftUI
import SwiftData

/// The main entry screen of the app.
///
/// Lets the user log water intake via preset buttons or a custom amount,
/// view progress toward their daily goal, undo the last drink, reset the day,
/// and change their daily goal target.
struct HomeView: View {
    @Query var waterData: [WaterData]
    @Environment(\.modelContext) var context

    /// Bound to the custom-amount text field.
    @State private var customAmount: String = ""
    /// Controls visibility of the goal-editor sheet.
    @State private var showGoalEditor = false
    /// Holds the draft goal value while the editor sheet is open.
    @State private var newGoalText: String = ""

    /// The user's current daily goal, falling back to 2000 ml if no data exists yet.
    var goal: Int {
        waterData.first?.dailyGoal ?? 2000
    }

    /// Progress toward the daily goal, clamped to [0, 1].
    var progress: Double {
        guard let data = waterData.first else { return 0.0 }
        return min(Double(data.totalWater) / Double(data.dailyGoal), 1.0)
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

                HStack(spacing: 10) {
                    TextField("Custom ml", text: $customAmount)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 110)
                    Button("Add") {
                        if let amount = Int(customAmount), amount > 0 {
                            addWater(amount, to: data)
                            customAmount = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(Int(customAmount) == nil || (Int(customAmount) ?? 0) <= 0)
                }

                HStack(spacing: 20) {
                    Button("↩ Undo") {
                        data.undoLastDrink()
                    }
                    .disabled(data.lastDrinkAmount == 0)
                    .foregroundStyle(.orange)

                    Button("Reset") {
                        data.totalWater = 0
                        data.lastUpdated = Date()
                        data.lastDrinkAmount = 0
                    }
                    .foregroundStyle(.red)
                }

                ProgressView(value: progress)
                    .tint(progress >= 1.0 ? .green : .blue)
                    .padding()

                Text("\(Int(progress * 100))% of \(goal) ml goal")
                    .font(.headline)

                Button("Set Goal") {
                    newGoalText = "\(data.dailyGoal)"
                    showGoalEditor = true
                }
                .font(.subheadline)

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
        .sheet(isPresented: $showGoalEditor) {
            goalEditorSheet
        }
        .onAppear {
            if waterData.isEmpty {
                let newData = WaterData()
                context.insert(newData)
            } else if let data = waterData.first {
                resetIfNewDay(data)
            }
        }
    }

    /// The sheet content for editing the daily goal.
    var goalEditorSheet: some View {
        NavigationStack {
            Form {
                Section("Daily Goal (ml)") {
                    TextField("Goal in ml", text: $newGoalText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Set Daily Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let g = Int(newGoalText), g > 0, let data = waterData.first {
                            data.dailyGoal = g
                        }
                        showGoalEditor = false
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showGoalEditor = false }
                }
            }
        }
    }

    /// Logs a drink of `amount` ml, handles daily reset, saves `lastDrinkAmount` for undo,
    /// and triggers a streak update if the goal is crossed for the first time today.
    func addWater(_ amount: Int, to data: WaterData) {
        resetIfNewDay(data)

        let wasBelowGoal = data.totalWater < data.dailyGoal

        data.lastDrinkAmount = amount
        data.totalWater += amount
        data.lastUpdated = Date()

        if wasBelowGoal && data.totalWater >= data.dailyGoal {
            updateStreak(for: data)
        }
    }
    /// Updates the streak when the user first hits their goal on a given day.
    /// Increments for consecutive days, resets if a day was missed.
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
    
    /// Resets today's water intake to zero if `lastUpdated` is from a previous calendar day.
    func resetIfNewDay(_ data: WaterData) {
        if !Calendar.current.isDate(data.lastUpdated, inSameDayAs: Date()) {
            data.totalWater = 0
            data.lastUpdated = Date()
            data.lastDrinkAmount = 0
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: WaterData.self, inMemory: true)
}
