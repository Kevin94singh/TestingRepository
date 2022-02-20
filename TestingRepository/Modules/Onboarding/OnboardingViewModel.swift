import Foundation

final class OnboardingViewModel: BaseViewModel {
    func setDidShowOnboarding() {
        UserDefaults.didShowOnboarding = true
    }
}
