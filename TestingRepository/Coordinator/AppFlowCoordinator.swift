import RxSwift
import UIKit

final class AppFlowCoordinator: BaseCoordinator<NoDeepLink> {
    private var window: UIWindow!
    
    // MARK: - Dispose bag
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func start(in window: UIWindow) {
        super.start(in: window)
        self.window = window
        
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        
        window.rootViewController = vc
        rootViewController = vc
        
        UserDefaults.didShowOnboarding ? appFlowDelegateShowMainFlow() : appFlowDelegateShowOnboarding()
    }
}

extension AppFlowCoordinator: AppFlowDelegate {
    func appFlowDelegateShowMainFlow() {
        let coordinator = MainFlowCoordinator()
        addChild(coordinator)
        coordinator.flowDelegate = self
        coordinator.start(in: window)
    }
    
    func appFlowDelegateShowOnboarding() {
        let coordinator = OnboardingFlowCoordinator()
        addChild(coordinator)
        coordinator.flowDelegate = self
        coordinator.start(in: window)
    }
}
