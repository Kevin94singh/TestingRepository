import Stevia
import UIKit

final class OnboardingViewController: BaseViewController<OnboardingViewModel> {
    private lazy var continueButton: AnimatedButton = {
        let button = AnimatedButton.clearMain()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle(Localizable.onboardingCta(), for: .normal)
        return button
    }()
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        
        let titleLabel = UILabel.white(font: .systemFont(ofSize: 20, weight: .semibold))
        titleLabel.textAlignment = .left
        titleLabel.text(Localizable.onboardingTitle())
        
        let descriptionLabel = UILabel.white(font: .systemFont(ofSize: 14, weight: .regular))
        descriptionLabel.text(Localizable.onboardingDescription())
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        view.sv(
            stackView,
            continueButton
        )
        
        stackView.left(16).centerVertically()
        continueButton.bottom(5%).height(52).width(90%).centerHorizontally()
    }
    
    override func setStyle() {
        super.setStyle()
        setDefaultAttributesFor(style: .main, for: self)
    }
    
    override func bind() {
        super.bind()
        bindAction()
    }
}

extension OnboardingViewController {
    func bindAction() {
        continueButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.viewModel.setDidShowOnboarding()
                self?.delegate?.onboardingViewControllerDelegateShowMainFlow()
            }).disposed(by: disposeBag)
    }
}
