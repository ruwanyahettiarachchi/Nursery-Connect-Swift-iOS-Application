import SwiftUI

enum NurseryTheme {
    /// Soft teal — calm, professional
    static let accent = Color(red: 0.28, green: 0.58, blue: 0.62)
    /// Gentle mint for highlights
    static let mint = Color(red: 0.55, green: 0.78, blue: 0.72)
    /// Sky blue for diary / learning
    static let diaryTint = Color(red: 0.35, green: 0.62, blue: 0.78)
    /// Warm amber for incidents (attention without alarm)
    static let incidentTint = Color(red: 0.92, green: 0.62, blue: 0.35)

    static let pageBackgroundTop = Color(red: 0.93, green: 0.97, blue: 0.98)
    static let pageBackgroundBottom = Color(red: 0.90, green: 0.96, blue: 0.94)

    static let cardBackground = Color.white.opacity(0.92)
    static let cardShadow = Color.black.opacity(0.07)

    static var pageBackground: some View {
        LinearGradient(
            colors: [pageBackgroundTop, pageBackgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct NurseryCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(NurseryTheme.cardBackground)
                    .shadow(color: NurseryTheme.cardShadow, radius: 10, x: 0, y: 4)
            )
    }
}

extension View {
    func nurseryCard() -> some View {
        modifier(NurseryCardModifier())
    }
}
