import SwiftUI
import SwiftData

struct QuestView: View {
    @Query var waterData: [WaterData]

    var totalWater: Int {
        waterData.first?.totalWater ?? 0
    }

    var dailyGoal: Int {
        waterData.first?.dailyGoal ?? 2000
    }

    var quests: [(title: String, completed: Bool)] {
        let half = dailyGoal / 2
        let quarter = dailyGoal / 4
        return [
            ("Drink \(quarter) ml", totalWater >= quarter),
            ("Drink \(half) ml", totalWater >= half),
            ("Reach \(dailyGoal) ml goal", totalWater >= dailyGoal)
        ]
    }

    var completedQuestCount: Int {
        quests.filter { $0.completed }.count
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Daily Quests")
                .font(.largeTitle)
                .bold()

            Text("Quests Completed: \(completedQuestCount) / \(quests.count)")
                .font(.headline)

            ProgressView(value: Double(completedQuestCount), total: Double(quests.count))
                .tint(completedQuestCount == quests.count ? .green : .blue)
                .padding(.horizontal)

            VStack(spacing: 15) {
                ForEach(quests, id: \.title) { quest in
                    questRow(
                        title: quest.title,
                        completed: quest.completed
                    )
                }
            }
            .padding()

            if completedQuestCount == quests.count {
                Text("🎉 All daily quests completed!")
                    .font(.title3)
                    .foregroundStyle(.green)
            }

            Text("Water today: \(totalWater) ml")
                .font(.headline)

            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    func questRow(title: String, completed: Bool) -> some View {
        HStack {
            Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(completed ? .green : .gray)
                .font(.title2)

            Text(title)
                .font(.title3)

            Spacer()
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    QuestView()
        .modelContainer(for: WaterData.self, inMemory: true)
}
