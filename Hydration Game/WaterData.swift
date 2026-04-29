import SwiftData
import Foundation

@Model
class WaterData {

    // MARK: - Core Data
    var totalWater: Int = 0
    var lastUpdated: Date = Date()

    // MARK: - Streak System
    var streak: Int = 0
    var bestStreak: Int = 0
    var lastGoalDate: Date? = nil
    var dailyGoal: Int = 2000
    var lastDrinkAmount: Int = 0

    // MARK: - Init
    init(
        totalWater: Int = 0,
        lastUpdated: Date = Date(),
        streak: Int = 0,
        bestStreak: Int = 0,
        lastGoalDate: Date? = nil,
        dailyGoal: Int = 2000,
        lastDrinkAmount: Int = 0
    ) {
        self.totalWater = totalWater
        self.lastUpdated = lastUpdated
        self.streak = streak
        self.bestStreak = bestStreak
        self.lastGoalDate = lastGoalDate
        self.dailyGoal = dailyGoal
        self.lastDrinkAmount = lastDrinkAmount
    }

    // MARK: - Add Water
    func addWater(amount: Int, goal: Int = 2000) {
        totalWater += amount
        lastUpdated = Date()

        checkGoal(goal: goal)
    }

    // MARK: - Undo Last Drink
    func undoLastDrink() {
        guard lastDrinkAmount > 0 else { return }
        totalWater = max(0, totalWater - lastDrinkAmount)
        lastDrinkAmount = 0
        lastUpdated = Date()
    }

    // MARK: - Goal + Streak Logic
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
    func resetDailyWaterIfNeeded() {
        let calendar = Calendar.current

        if !calendar.isDate(lastUpdated, inSameDayAs: Date()) {
            totalWater = 0
            lastUpdated = Date()
        }
    }

    // MARK: - Full Reset
    func resetAllData() {
        totalWater = 0
        streak = 0
        bestStreak = 0
        lastGoalDate = nil
        lastUpdated = Date()
    }
}
