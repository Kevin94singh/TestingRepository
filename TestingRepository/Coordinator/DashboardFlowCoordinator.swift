import UIKit

final class DashboardFlowCoordinator: BaseCoordinator<NoDeepLink> {
    weak var flowDelegate: AppFlowDelegate?
    
    private lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = .green
        return tabBarController
    }()
    
    override func start(in window: UIWindow) {
        let style = AppStyle.main
        style.apply(textStyle: .tabBar, to: tabBarController.tabBar)
        
        let dashboardViewController = DashboardViewController(viewModel: DashboardViewModel(dependencies: dependencies))
        dashboardViewController.delegate = self
        let dashboardNavigationController = UINavigationController(rootViewController: dashboardViewController)
        dashboardNavigationController.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "explorer-unselected"), selectedImage: UIImage(named: "explorer-selected"))
        
        let aboutViewController = AboutYouViewController()
        let aboutNavigationController = UINavigationController(rootViewController: aboutViewController)
        aboutNavigationController.tabBarItem = UITabBarItem(title: "About", image: UIImage(named: "about-unselected"), selectedImage: UIImage(named: "about-selected"))
        
        tabBarController.viewControllers = [dashboardNavigationController, aboutNavigationController]
        let navigationController = UINavigationController(rootViewController: tabBarController)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        window.rootViewController = navigationController
        rootViewController = navigationController
        self.navigationController = navigationController
    }
}

extension DashboardFlowCoordinator: DashboardViewControllerDelegate {
    func dashboardViewControllerDelegateShowUser(detail: User) {
        let viewController = UserDetailViewController(viewModel: UserDetailViewModel(user: detail))
        viewController.delegate = self
        viewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(viewController, animated: true)
    }
}

extension DashboardFlowCoordinator: UserDetailViewControllerDelegate {
    func userDetailViewControllerDelegateDismiss(viewController: UserDetailViewController) {
        viewController.dismiss(animated: true)
    }
}
