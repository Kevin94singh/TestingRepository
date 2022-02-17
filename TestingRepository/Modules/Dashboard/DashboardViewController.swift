import Stevia
import UIKit

final class DashboardViewController: BaseViewController<BaseViewModel> {
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        super.bind()
        bindAction()
    }
    
    override func setStyle() {
        super.setStyle()
        setDefaultAttributesFor(style: .main, for: self)
    }
}

extension DashboardViewController {
    func bindAction() {
        
    }
}
