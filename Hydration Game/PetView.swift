import SwiftUI
import SwiftData

struct PetView: View {
    @Query var waterData: [WaterData]

    let goal = 2000

    var totalWater: Int {
        waterData.first?.totalWater ?? 0
    }

    // Hydra growth logic (infinite, slows down over time)
    var hydraHeads: Int {
        max(1, Int(sqrt(Double(totalWater) / 500.0)))
    }

    var hydraDisplay: String {
        String(repeating: "🐉", count: hydraHeads)
    }

    var petMood: String {
        if totalWater >= goal {
            return "ecstatic"
        } else if totalWater >= 1000 {
            return "content"
        } else if totalWater > 0 {
            return "sleepy"
        } else {
            return "thirsty"
        }
    }

    var moodMessage: String {
        switch petMood {
        case "ecstatic":
            return "Your hydra is thriving. It loved today’s hydration."
        case "content":
            return "Your hydra is doing well. Keep going."
        case "sleepy":
            return "Your hydra needs more water to wake up."
        default:
            return "Your hydra is very thirsty."
        }
    }

    var body: some View {
        VStack(spacing: 20) {

            Text("Hydra Pet")
                .font(.largeTitle)
                .bold()

            // Hydra display (growing heads)
            Text(hydraDisplay)
                .font(.system(size: 60))
                .multilineTextAlignment(.center)

            // Head count
            Text("Heads: \(hydraHeads)")
                .font(.headline)

            // Mood message
            Text(moodMessage)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Water info
            Text("Water today: \(totalWater) ml")
                .font(.headline)

            // Progress bar
            ProgressView(value: Double(totalWater), total: Double(goal))
                .tint(totalWater >= goal ? .green : .blue)
                .padding(.horizontal)

            // Feedback message
            if totalWater >= goal {
                Text("Your hydra grew stronger today.")
                    .foregroundStyle(.green)
            } else {
                Text("Feed your hydra more water by hitting your goal.")
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    PetView()
        .modelContainer(for: WaterData.self, inMemory: true)
}
