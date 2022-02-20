import UIKit

final class MainFlowCoordinator: BaseCoordinator<NoDeepLink> {
    weak var flowDelegate: AppFlowDelegate?
    
    private lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        return tabBarController
    }()
    
    override func start(in window: UIWindow) {
        let style = AppStyle.main
        style.apply(textStyle: .tabBar, to: tabBarController.tabBar)
        
        let storiesViewController = StoriesViewController(viewModel: StoriesViewModel(dependencies: dependencies))
        storiesViewController.delegate = self
        let storiesNavigationController = UINavigationController(rootViewController: storiesViewController)
        storiesNavigationController.tabBarItem = UITabBarItem(title: Localizable.storiesTitle(), image:Images.explorerUnselected(), selectedImage: Images.explorerSelected())
        
        let aboutViewController = AboutYouViewController()
        let aboutNavigationController = UINavigationController(rootViewController: aboutViewController)
        aboutNavigationController.tabBarItem = UITabBarItem(title: Localizable.aboutTitle(), image: Images.aboutUnselected(), selectedImage: Images.aboutSelected())
        
        tabBarController.viewControllers = [storiesNavigationController, aboutNavigationController]
        let navigationController = UINavigationController(rootViewController: tabBarController)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        window.rootViewController = navigationController
        rootViewController = navigationController
        self.navigationController = navigationController
    }
}

extension MainFlowCoordinator: StoriesViewControllerDelegate {
    func storiesViewControllerDelegateShowUser(detail: User) {
        let viewController = UserDetailViewController(viewModel: UserDetailViewModel(user: detail))
        viewController.delegate = self
        viewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(viewController, animated: true)
    }
}

extension MainFlowCoordinator: UserDetailViewControllerDelegate {
    func userDetailViewControllerDelegateDismiss(viewController: UserDetailViewController) {
        viewController.dismiss(animated: true)
    }
}
