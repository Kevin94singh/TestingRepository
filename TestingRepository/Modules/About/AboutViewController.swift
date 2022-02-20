import Stevia
import UIKit

final class AboutYouViewController: BaseViewControllerNoVM {
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let label = UILabel.white(font: .systemFont(ofSize: 17, weight: .regular))
        label.textAlignment = .center
        label.text(Localizable.aboutDescription())
        
        view.sv(label)
        label.centerInContainer()
    }
    
    // MARK: - Style
    
    override func setStyle() {
        super.setStyle()
        setDefaultAttributesFor(style: .main, for: self, title: Localizable.aboutTitle())
    }
}
