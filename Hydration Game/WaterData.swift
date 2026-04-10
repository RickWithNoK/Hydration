import SwiftData
import Foundation

@Model
class WaterData {
    var totalWater: Int
    var lastUpdated: Date
    
    init(totalWater: Int = 0, lastUpdated: Date = Date()) {
        self.totalWater = totalWater
        self.lastUpdated = lastUpdated
    }
}
