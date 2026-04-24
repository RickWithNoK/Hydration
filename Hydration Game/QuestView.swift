import SwiftUI
import SwiftData

struct QuestView: View {
    @Query var waterData: [WaterData]

    var totalWater: Int {
        waterData.first?.totalWater ?? 0
    }

    var quests: [(title: String, completed: Bool)] {
        [
            ("Drink 500 ml", totalWater >= 500),
            ("Drink 1000 ml", totalWater >= 1000),
            ("Reach 2000 ml goal", totalWater >= 2000)
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
