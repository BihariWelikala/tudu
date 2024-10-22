import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            // Purple background
            Color(hex: "#4B0082")
                .ignoresSafeArea() // Make sure the color covers the entire screen
            
            // White "Tudu" text
            Text("Tudu")
                .font(.system(size: 50, weight: .bold, design: .rounded)) // Large, bold text
                .foregroundColor(.white) // White color
        }
    }
}

#Preview {
    SplashScreen()
}
