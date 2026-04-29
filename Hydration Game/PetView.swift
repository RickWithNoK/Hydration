import SwiftUI
import SwiftData

struct PetView: View {
    @Query var waterData: [WaterData]

    var data: WaterData? {
        waterData.first
    }

    var goal: Int {
        data?.dailyGoal ?? 2000
    }

    var totalWater: Int {
        data?.totalWater ?? 0
    }

    var streak: Int {
        data?.streak ?? 0
    }

    var bestStreak: Int {
        data?.bestStreak ?? 0
    }

    // Smooth streak scaling (capped)
    var streakBoost: Double {
        let boost = 1.0 + (Double(streak) / 3.0 * 0.1)
        return min(boost, 2.0)
    }

    var boostedWater: Double {
        Double(totalWater) * streakBoost
    }

    // Hydra growth (infinite but slows)
    var hydraHeads: Int {
        max(1, Int(sqrt(boostedWater / 500.0)))
    }

    var hydraDisplay: String {
        String(repeating: "🐉", count: hydraHeads)
    }

    // Mood system
    var petMood: String {
        if totalWater >= goal {
            return "ecstatic"
        } else if totalWater >= goal / 2 {
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

    // Streak milestones
    var streakMessage: String {
        if streak >= 30 {
            return "Legendary streak! Your hydra is evolving rapidly."
        } else if streak >= 14 {
            return "Huge streak! Your hydra feels powerful."
        } else if streak >= 7 {
            return "One-week streak! Your hydra is getting stronger."
        } else if streak >= 3 {
            return "Nice streak! Growth boost activated."
        } else {
            return "Reach a 3-day streak to boost hydra growth."
        }
    }

    var body: some View {
        VStack(spacing: 20) {

            Text("Hydra Pet")
                .font(.largeTitle)
                .bold()

            // Hydra visual
            Text(hydraDisplay)
                .font(.system(size: 60))
                .multilineTextAlignment(.center)

            Text("Heads: \(hydraHeads)")
                .font(.headline)

            // Mood
            Text(moodMessage)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Water
            Text("Water today: \(totalWater) ml")
                .font(.headline)

            // Streak info
            Text("Current Streak: \(streak) days")
                .font(.headline)
                .foregroundStyle(.orange)

            Text("Best Streak: \(bestStreak) days")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Streak Boost: \(String(format: "%.1fx", streakBoost))")
                .font(.headline)
                .foregroundStyle(.purple)

            Text(streakMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Progress bar
            ProgressView(value: Double(totalWater), total: Double(goal))
                .tint(totalWater >= goal ? .green : .blue)
                .padding(.horizontal)

            // Feedback
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
