import UIKit

final class OnboardingFlowCoordinator: BaseCoordinator<NoDeepLink> {
    weak var flowDelegate: AppFlowDelegate?
    
    override func start(in window: UIWindow) {
        super.start(in: window)
        
        let viewController = OnboardingViewController(viewModel: OnboardingViewModel())
        viewController.delegate = self
        
        window.rootViewController = viewController
        rootViewController = viewController
    }
}

extension OnboardingFlowCoordinator: OnboardingViewControllerDelegate {
    func onboardingViewControllerDelegateShowMainFlow() {
        flowDelegate?.appFlowDelegateShowMainFlow()
    }
}
