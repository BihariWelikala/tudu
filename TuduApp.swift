import SwiftUI

@main
struct TuduApp: App {
    @State private var showSplashScreen = true

    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashScreen()
                    .onAppear {
                        // Automatically switch to ContentView after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSplashScreen = false
                        }
                    }
            } else {
                ContentView() // Main content
            }
        }
    }
}
