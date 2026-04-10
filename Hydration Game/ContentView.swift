
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "drop.fill")
                }

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
            PetView()
                .tabItem {
                    Label("Pet", systemImage: "heart.fill")
                }
            QuestView()
                .tabItem {
                    Label("Quest", systemImage: "star.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
