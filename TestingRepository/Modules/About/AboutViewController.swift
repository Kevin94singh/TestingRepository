import Stevia
import UIKit

final class AboutYouViewController: BaseViewControllerNoVM {
    
    override func setStyle() {
        super.setStyle()
        setDefaultAttributesFor(style: .main, for: self, title: Localizable.aboutTitle())
    }
}
