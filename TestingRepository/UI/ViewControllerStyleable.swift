import UIKit

protocol ViewControllerStyleable {
    
    func setStyle()
    func setDefaultAttributesFor(style: AppStyle, for viewController: UIViewController)
    func setDefaultAttributesFor(style: AppStyle, for viewController: UIViewController, title: String?)
}

extension ViewControllerStyleable {
    
    func setDefaultAttributesFor(style: AppStyle, for viewController: UIViewController) {
        if let navigationBar = viewController.navigationController?.navigationBar {
            style.apply(to: navigationBar)
        }
        
        viewController.view.backgroundColor = style.backgroundColor
    }
    
    func setDefaultAttributesFor(style: AppStyle, for viewController: UIViewController, title: String?) {
        self.setDefaultAttributesFor(style: style, for: viewController)
        if let title = title {
            let titleLabel = UILabel.white()
            titleLabel.text = title
            titleLabel.textAlignment = .left
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
            viewController.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}
