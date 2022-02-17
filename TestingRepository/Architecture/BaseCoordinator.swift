import UIKit
import os.log

class BaseCoordinator<DeepLinkType>: NSObject, UINavigationControllerDelegate {
    
    /// Turn on/off logging of init/deinit of all FCs
    var flowCoordinatorMemoryLoggingEnabled: Bool = true
    
    /// Reference to the navigation controller used within the flow
    weak var navigationController: UINavigationController?
    
    /// First VC of the flow. Must be set when FC starts.
    weak var rootViewController: UIViewController!
    
    /// Parent coordinator
    weak var parentCoordinator: BaseCoordinator?
    
    /// Array of child coordinators
    var childCoordinators = [BaseCoordinator]()
    
    /// Currently active coordinator
    weak var activeChild: BaseCoordinator?
    
    // MARK: - Lifecycle
    
    /// Just start and return rootViewController. Object calling this method will connect returned view controller to the flow.
    @discardableResult
    func start() -> UIViewController {
        checkRootViewController()
        
        return UIViewController()
    }
    
    /// Start in window. Window's root VC is supposed to be set.
    func start(in window: UIWindow) {
        checkRootViewController()
    }
    
    /// Start within existing navigation controller.
    func start(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.delegate = self
        
        checkRootViewController()
    }
    
    /// Start by presenting from given VC. This method must be overriden by subclass.
    func start(from viewController: UIViewController) {
        checkRootViewController()
    }
    
    /// Clean up. Must be called when FC finished the flow to avoid memory leaks and unexpcted behavior.
    func stop(animated: Bool = false) {
        
        /// stop all children
        childCoordinators.forEach { $0.stop(animated: animated) }
        
        /// dismiss all VCs presented from root or nav
        if rootViewController.presentedViewController != nil {
            rootViewController.dismiss(animated: animated)
        }
        
        // dismiss when root was presented
        rootViewController.presentingViewController?.dismiss(animated: animated)
        
        // pop all view controllers when started within navigation controller
        if let index = navigationController?.viewControllers.firstIndex(of: rootViewController) {
            // VCs to be removed from navigation stack
            let toRemoveViewControllers = navigationController.flatMap { Array($0.viewControllers[index..<$0.viewControllers.count]) } ?? []
            
            // dismiss all presented VCs on VCs to be removed
            toRemoveViewControllers.forEach { vc in
                if vc.presentedViewController != nil {
                    vc.dismiss(animated: animated)
                }
            }
            
            // VCs to remain in the navigation stack
            let remainingViewControllers = Array(navigationController?.viewControllers[0..<index] ?? [])
            navigationController?.setViewControllers(remainingViewControllers, animated: animated)
        }
        
        // stopping FC doesn't need to be nav delegate anymore -> pass it to parent
        navigationController?.delegate = parentCoordinator
        
        parentCoordinator?.removeChild(self)
    }
    
    // MARK: - Child coordinators
    
    func addChild(_ flowController: BaseCoordinator) {
        if !childCoordinators.contains{$0 === flowController} {
            childCoordinators.append(flowController)
            flowController.parentCoordinator = self
        }
    }
    
    func removeChild(_ flowController: BaseCoordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === flowController }) {
            childCoordinators.remove(at: index)
        }
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // ensure the view controller is popping
        guard
            let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromViewController)
        else { return }
        
        if let firstViewController = rootViewController, fromViewController == firstViewController {
            navigationController.delegate = parentCoordinator
            stop()
        }
    }
    
    // MARK: - DeepLink
    
    /// Handle deep link with currently active coordinator. If not handled, function returns false
    @discardableResult func handleDeeplink(_ deeplink: DeepLinkType) -> Bool {
        return activeChild?.handleDeeplink(deeplink) ?? false
    }
    
    // MARK: - Debug
    
    override init() {
        super.init()
        if flowCoordinatorMemoryLoggingEnabled {
            os_log("🔀 👶 %@", log: Logger.lifecycleLog(), type: .info, "\(self)")
        }
    }
    
    deinit {
        if flowCoordinatorMemoryLoggingEnabled {
            os_log("🔀 ⚰️ %@", log: Logger.lifecycleLog(), type: .info, "\(self)")
        }
    }
    
    /// Wait for a second and check whether rootViewController was set
    private func checkRootViewController() {
        // MARK: TODO
        //DispatchQueue(label: "rootViewController").asyncAfter(deadline: .now() + 1) { [weak self] in
        //if self?.rootViewController == nil { assertionFailure("rootViewController is nil") }
        //}
    }
}

/// Empty class for FlowCoordinator with no deep link handling
enum NoDeepLink {}

