
import SwiftUI

/// The root view of the app.
///
/// Hosts a `TabView` with four tabs:
/// - **Home** — log water and manage daily goal
/// - **Stats** — view streaks and hydra boost
/// - **Pet** — see the Hydra pet grow
/// - **Quest** — track daily quest completion
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
