import SwiftUI
import SwiftData

/// Displays the user's Hydra pet, whose appearance and mood are driven
/// by how much water has been consumed and the current streak.
///
/// - The number of dragon heads grows with boosted water intake.
/// - The pet's mood ranges from "thirsty" to "ecstatic" based on goal progress.
/// - Streak milestones unlock messages and a growth multiplier (up to 2×).
struct PetView: View {
    @Query var waterData: [WaterData]

    var data: WaterData? {
        waterData.first
    }

    /// The user's daily goal in ml, read from persisted data.
    var goal: Int {
        data?.dailyGoal ?? 2000
    }

    /// Total water consumed today in ml.
    var totalWater: Int {
        data?.totalWater ?? 0
    }

    var streak: Int {
        data?.streak ?? 0
    }

    var bestStreak: Int {
        data?.bestStreak ?? 0
    }

    /// Streak-based multiplier applied to water intake for hydra growth calculations.
    /// Scales as `1.0 + (streak / 3) * 0.1`, capped at 2.0×.
    var streakBoost: Double {
        let boost = 1.0 + (Double(streak) / 3.0 * 0.1)
        return min(boost, 2.0)
    }

    /// `totalWater` scaled by the streak boost multiplier.
    var boostedWater: Double {
        Double(totalWater) * streakBoost
    }

    /// Number of dragon heads shown, derived from `boostedWater` via a square-root curve.
    /// Minimum of 1 head; slows as intake grows.
    var hydraHeads: Int {
        max(1, Int(sqrt(boostedWater / 500.0)))
    }

    /// String of dragon emoji, one per head.
    var hydraDisplay: String {
        String(repeating: "🐉", count: hydraHeads)
    }

    /// The pet's current mood, determined by progress toward the daily goal.
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

    /// Human-readable message matching the current `petMood`.
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

    /// Motivational message tied to streak milestone thresholds (3, 7, 14, 30 days).
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
