import Stevia
import UIKit

final class AboutYouViewController: BaseViewControllerNoVM {
    override func loadView() {
        super.loadView()
        
        let label = UILabel.white(font: .systemFont(ofSize: 17, weight: .regular))
        label.textAlignment = .center
        label.text("Kevin Singh, 2022")
        
        view.sv(label)
        label.centerInContainer()
    }
    
    override func setStyle() {
        super.setStyle()
        setDefaultAttributesFor(style: .main, for: self, title: Localizable.aboutTitle())
    }
}
