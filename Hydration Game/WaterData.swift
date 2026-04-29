import SwiftData
import Foundation

/// The single persistent model for the app.
/// Stores all hydration state — daily intake, streak tracking, and user preferences.
/// SwiftData automatically persists every `@Model` property.
@Model
class WaterData {

    // MARK: - Core Data
    /// Total water consumed today in millilitres.
    var totalWater: Int = 0
    /// Timestamp of the last time any water was logged.
    var lastUpdated: Date = Date()

    // MARK: - Streak System
    /// Number of consecutive days the user has hit their daily goal.
    var streak: Int = 0
    /// The highest streak the user has ever achieved.
    var bestStreak: Int = 0
    /// The last calendar day on which the daily goal was reached.
    var lastGoalDate: Date? = nil
    /// The user-configured daily water goal in millilitres. Defaults to 2000 ml.
    var dailyGoal: Int = 2000
    /// The amount added in the most recent drink log, used to support undo.
    var lastDrinkAmount: Int = 0

    // MARK: - History
    /// Rolling log of the last 7 days' water intake in ml.
    /// Index 0 = oldest day, index 6 = today. Updated on each daily reset.
    var weeklyHistory: [Int] = []
    /// Cumulative total of all water ever logged across all days.
    var totalWaterAllTime: Int = 0

    // MARK: - Init
    init(
        totalWater: Int = 0,
        lastUpdated: Date = Date(),
        streak: Int = 0,
        bestStreak: Int = 0,
        lastGoalDate: Date? = nil,
        dailyGoal: Int = 2000,
        lastDrinkAmount: Int = 0,
        weeklyHistory: [Int] = [],
        totalWaterAllTime: Int = 0
    ) {
        self.totalWater = totalWater
        self.lastUpdated = lastUpdated
        self.streak = streak
        self.bestStreak = bestStreak
        self.lastGoalDate = lastGoalDate
        self.dailyGoal = dailyGoal
        self.lastDrinkAmount = lastDrinkAmount
        self.weeklyHistory = weeklyHistory
        self.totalWaterAllTime = totalWaterAllTime
    }

    // MARK: - Add Water
    /// Adds `amount` ml to today's total and checks whether the daily goal has been reached.
    /// - Parameters:
    ///   - amount: Millilitres to add.
    ///   - goal: The daily target to evaluate streaks against.
    func addWater(amount: Int, goal: Int = 2000) {
        totalWater += amount
        lastUpdated = Date()

        checkGoal(goal: goal)
    }

    // MARK: - Undo Last Drink
    /// Reverses the most recently logged drink.
    /// Does nothing if no drink has been logged since the last undo.
    func undoLastDrink() {
        guard lastDrinkAmount > 0 else { return }
        totalWater = max(0, totalWater - lastDrinkAmount)
        lastDrinkAmount = 0
        lastUpdated = Date()
    }

    // MARK: - Goal + Streak Logic
    /// Evaluates whether the daily goal has been met and updates the streak accordingly.
    /// Increments the streak if the goal was last reached yesterday, resets it if a day was skipped,
    /// and guards against double-counting the same calendar day.
    private func checkGoal(goal: Int) {
        guard totalWater >= goal else { return }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastGoalDate {
            let lastDay = calendar.startOfDay(for: lastGoalDate)

            // Already counted today
            if calendar.isDate(lastDay, inSameDayAs: today) {
                return
            }

            // Continued streak (yesterday)
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
               calendar.isDate(lastDay, inSameDayAs: yesterday) {
                streak += 1
            } else {
                // Missed day → reset
                streak = 1
            }
        } else {
            // First time ever
            streak = 1
        }

        lastGoalDate = today

        if streak > bestStreak {
            bestStreak = streak
        }
    }

    // MARK: - Daily Reset
    /// Resets `totalWater` to zero if the last log was on a previous calendar day.
    /// Archives the completed day's intake into `weeklyHistory` (capped at 7 entries).
    /// Called automatically on app launch and before each water addition.
    func resetDailyWaterIfNeeded() {
        let calendar = Calendar.current

        if !calendar.isDate(lastUpdated, inSameDayAs: Date()) {
            // Archive yesterday's total before resetting
            weeklyHistory.append(totalWater)
            if weeklyHistory.count > 7 {
                weeklyHistory.removeFirst(weeklyHistory.count - 7)
            }
            totalWater = 0
            lastUpdated = Date()
            lastDrinkAmount = 0
        }
    }

    // MARK: - Full Reset
    /// Wipes all hydration history: intake, streaks, and goal date.
    func resetAllData() {
        totalWater = 0
        streak = 0
        bestStreak = 0
        lastGoalDate = nil
        lastUpdated = Date()
    }
}
