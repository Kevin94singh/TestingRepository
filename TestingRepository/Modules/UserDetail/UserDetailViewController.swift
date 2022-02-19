import Stevia
import UIKit

final class UserDetailViewController: BaseViewController<UserDetailViewModel> {
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private lazy var userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setImage(urlString: viewModel.user.avatarImageUrl, placeholder: UIImage(named: "user-placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel.white(font: .systemFont(ofSize: 20, weight: .semibold))
        label.text(viewModel.user.displayName ?? "")
        label.textAlignment = .center
        return label
    }()
      
      private lazy var storiesCountLabel: UILabel = {
        let label = UILabel.white(font: .systemFont(ofSize: 17, weight: .semibold))
        label.textAlignment = .center
        label.text("\(viewModel.user.stories ?? 0)")
        return label
    }()
    
    private lazy var followersValueLabel: UILabel = {
        let label = UILabel.white(font: .systemFont(ofSize: 17, weight: .semibold))
        label.textAlignment = .center
        label.text("\(viewModel.user.followers ?? 0)")
        return label
    }()
    
    private lazy var followingValueLabel: UILabel = {
        let label = UILabel.white(font: .systemFont(ofSize: 17, weight: .semibold))
        label.textAlignment = .center
        label.text("\(viewModel.user.following ?? 0)")
        return label
    }()
    
    private var masterStackView: UIStackView?
    
    weak var delegate: UserDetailViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        let storiesLabel = UILabel.white(font: .systemFont(ofSize: 14, weight: .regular))
        storiesLabel.text("Stories")
        storiesLabel.textAlignment = .center
        
        let followersLabel = UILabel.white(font: .systemFont(ofSize: 14, weight: .regular))
        followersLabel.text("Followers")
        followersLabel.textAlignment = .center
        
        let followingLabel = UILabel.white(font: .systemFont(ofSize: 14, weight: .regular))
        followingLabel.text("Following")
        followingLabel.textAlignment = .center
        
        let storiesStackView = UIStackView(arrangedSubviews: [storiesCountLabel, storiesLabel])
        storiesStackView.axis = .vertical
        storiesStackView.spacing = 2
        storiesStackView.distribution = .fillEqually
        storiesStackView.alignment = .fill
        
        let followerstackView = UIStackView(arrangedSubviews: [followersValueLabel, followersLabel])
        followerstackView.axis = .vertical
        followerstackView.spacing = 2
        followerstackView.distribution = .fillEqually
        followerstackView.alignment = .fill
        
        let followingtackView = UIStackView(arrangedSubviews: [followingValueLabel, followingLabel])
        followingtackView.axis = .vertical
        followingtackView.spacing = 2
        followingtackView.distribution = .fillEqually
        followingtackView.alignment = .fill
        
        let masterStackView = UIStackView(arrangedSubviews: [storiesStackView, followerstackView, followingtackView])
        masterStackView.axis = .horizontal
        masterStackView.spacing = 20
        masterStackView.distribution = .fillEqually
        masterStackView.alignment = .fill
        
        view.sv(
            dismissButton,
            userAvatarImageView,
            userNameLabel,
            masterStackView
        )
        
        dismissButton.top(3%).right(20).size(20)
        
        userAvatarImageView.top(10%).centerHorizontally().size(80)
        
        userNameLabel.Top == userAvatarImageView.Bottom + 30
        userNameLabel.centerHorizontally()
        
        masterStackView.Top == userNameLabel.Bottom + 30
        masterStackView.centerHorizontally()
        
        [dismissButton, userAvatarImageView, userNameLabel, masterStackView].forEach { item in
            item.alpha = 0
        }
        
        self.masterStackView = masterStackView
    }
    
    override func bind() {
        super.bind()
        bindAction()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.7) {
            [self.dismissButton, self.userAvatarImageView, self.userNameLabel, self.masterStackView].forEach { item in
                item?.alpha = 1
            }
        }
    }
}

extension UserDetailViewController {
    func bindAction() {
        dismissButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.userDetailViewControllerDelegateDismiss(viewController: self)
            }).disposed(by: disposeBag)
    }
}
