import SwiftUI
import SwiftData

struct PetView: View {
    @Query var waterData: [WaterData]

    let goal = 2000

    var totalWater: Int {
        waterData.first?.totalWater ?? 0
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

    var hydraFace: String {
        switch petMood {
        case "ecstatic":
            return "🐉"
        case "content":
            return "🐲"
        case "sleepy":
            return "😴"
        default:
            return "🥺"
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

            Text(hydraFace)
                .font(.system(size: 100))

            Text(moodMessage)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Water today: \(totalWater) ml")
                .font(.headline)

            ProgressView(value: Double(totalWater), total: Double(goal))
                .tint(totalWater >= goal ? .green : .blue)
                .padding(.horizontal)

            if totalWater >= goal {
                Text("Your hydra grew stronger today.")
                    .foregroundStyle(.green)
            } else {
                Text("Feed your hydra more water by hitting your goal.")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    PetView()
        .modelContainer(for: WaterData.self, inMemory: true)
}
