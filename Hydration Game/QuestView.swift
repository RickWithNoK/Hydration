import SwiftUI
import SwiftData

struct QuestView: View {
    @Query var waterData: [WaterData]

    var totalWater: Int {
        waterData.first?.totalWater ?? 0
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Daily Quests")
                .font(.largeTitle)
                .bold()

            VStack(spacing: 15) {
                questRow(
                    title: "Drink 500 ml",
                    completed: totalWater >= 500
                )

                questRow(
                    title: "Drink 1000 ml",
                    completed: totalWater >= 1000
                )

                questRow(
                    title: "Reach 2000 ml goal",
                    completed: totalWater >= 2000
                )
            }
            .padding()

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
