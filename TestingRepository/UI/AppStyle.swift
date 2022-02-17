import UIKit

struct AppStyle {
    enum TextStyle {
        case navigationBar
        case tabBar
    }
    
    struct TextAttributes {
        let font: UIFont
        let color: UIColor
        let backgroundColor: UIColor?
        let selectedColor: UIColor?
        
        init(font: UIFont? = UIFont.systemFont(ofSize: 13), color: UIColor, selectedColor: UIColor? = .white, backgroundColor: UIColor? = nil) {
            self.font = font ?? UIFont.systemFont(ofSize: 13)
            self.color = color
            self.backgroundColor = backgroundColor
            self.selectedColor = selectedColor
        }
    }
    
    let backgroundColor: UIColor
    let preferredStatusBarStyle: UIStatusBarStyle
    let attributesForStyle: (_ style: TextStyle) -> TextAttributes
    
    init(backgroundColor: UIColor,
         preferredStatusBarStyle: UIStatusBarStyle = .default,
         attributesForStyle: @escaping (_ style: TextStyle) -> TextAttributes) {
        self.backgroundColor = backgroundColor
        self.preferredStatusBarStyle = preferredStatusBarStyle
        self.attributesForStyle = attributesForStyle
    }
    
    // MARK: NavigationBar
    
    func apply(textStyle: AppStyle.TextStyle = .navigationBar, to navigationBar: UINavigationBar) {
        let attributes = attributesForStyle(textStyle)
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: attributes.font,
            NSAttributedString.Key.foregroundColor: attributes.color
        ]
        
        // Used for barButtonItems
        navigationBar.tintColor = attributes.color
        
        // Used for background color
        navigationBar.barStyle = preferredStatusBarStyle == .default ? .default : .black
        navigationBar.barTintColor = attributes.backgroundColor
        navigationBar.isTranslucent = false
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = attributes.backgroundColor
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }
        
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = attributes.backgroundColor
    }
    
    // MARK: TabBar
    
    public func apply(textStyle: AppStyle.TextStyle = .tabBar, to tabBar: UITabBar) {
        
        let attributes = attributesForStyle(textStyle)
        tabBar.barTintColor = .black
        tabBar.tintColor = attributes.color
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = attributes.backgroundColor
            
            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.stackedLayoutAppearance = tabBarItemAppearance
            tabBar.backgroundColor = .red
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
}

extension AppStyle {
    static var main: AppStyle {
        return AppStyle(
            backgroundColor: .white,
            preferredStatusBarStyle: .default,
            attributesForStyle: { $0.mainAppAttributes }
        )
    }
}

private extension AppStyle.TextStyle {
    var mainAppAttributes: AppStyle.TextAttributes {
        switch self {
        case .navigationBar:
            return AppStyle.TextAttributes(font: UIFont.systemFont(ofSize: 18, weight: .bold), color: .white, backgroundColor: .red)
        case .tabBar:
            return AppStyle.TextAttributes(font: UIFont.systemFont(ofSize: 11), color: .white, backgroundColor: .clear)
        }
    }
}
