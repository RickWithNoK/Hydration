import SwiftUI

struct ContentView: View {
    @State private var totalWater = 0
    
    let goal = 2000
    
    var progress: Double {
        Double(totalWater) / Double(goal)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("💧 \(totalWater) ml")
                .font(.largeTitle)
            
            HStack(spacing: 15) {
                
                Button("250 ml") {
                    totalWater += 250
                }
                
                Button("500 ml") {
                    totalWater += 500
                }
                
                Button("1000 ml") {
                    totalWater += 1000
                }
                
                Button("Reset") {
                    totalWater = 0
                }
                .foregroundStyle(.red)
                    
            }
            .buttonStyle(.borderedProminent)
        }
            
        ProgressView(value: progress)
            .tint(progress >= 1.0 ? .green : .blue)
            .padding()
        
        Text("\(Int(progress * 100))% of daily goal")
            .font(.headline)
        
        if totalWater >= goal {
            Text("Goal Reached!")
                .font(.title2)
                .foregroundStyle(.green)
            
        }
    }
}
    
#Preview {
    ContentView()
}

