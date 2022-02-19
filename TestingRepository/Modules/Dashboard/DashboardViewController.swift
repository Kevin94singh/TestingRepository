import Stevia
import UIKit

final class DashboardViewController: BaseViewController<DashboardViewModel> {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DashboardCollectionViewCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.bounces = true
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel.white(font: .systemFont(ofSize: 17, weight: .regular))
        return label
    }()
    
    weak var delegate: DashboardViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        
        view.sv(
            collectionView,
            avatarImageView,
            usernameLabel
        )
        
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        avatarImageView.size(30).right(30)
        avatarImageView.Bottom == collectionView.Bottom - 20
        usernameLabel.CenterY == avatarImageView.CenterY
        usernameLabel.Right == avatarImageView.Left - 20
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
        setDefaultAttributesFor(style: .main, for: self, title: "Stories")
    }
    
    @objc
    private func avatarTapped() {
        guard let user = viewModel.dashboardData.value?.data.first?.user else { return } //same user always
        delegate?.dashboardViewControllerDelegateShowUser(detail: user)
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dashboardData.value?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DashboardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let data = viewModel.dashboardData.value?.data.first?.user?.collections, data.count > 0 else { return cell }
        cell.set(collection: data[indexPath.row])
        return cell
    }
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isPagingEnabled = scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)
    }
}

extension DashboardViewController {
    func bindAction() {
        
        viewModel.dashboardData
            .asDriver()
            .drive(onNext: { [weak self] (data) in
                guard let data = data else { return }
                self?.collectionView.reloadData()
                if let user = data.data.first?.user { /// User in API is still same
                    self?.avatarImageView.setImage(urlString: user.avatarImageUrl, placeholder: nil)
                    self?.usernameLabel.text(user.displayName ?? "")
                }
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
