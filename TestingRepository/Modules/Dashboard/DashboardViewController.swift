import Stevia
import UIKit

final class DashboardViewController: BaseViewController<DashboardViewModel> {
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDataAction.execute()
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
        
        viewModel.dashboardData
            .asDriver()
            .drive(onNext: { [weak self] (data) in
                guard let data = data else { return }
                // TODO Work with data
            }).disposed(by: disposeBag)
        
        viewModel.error
            .asDriver()
            .drive(onNext: { [weak self] (error) in
                guard let error = error else { return }
                // TODO Error
            }).disposed(by: disposeBag)
    }
}
