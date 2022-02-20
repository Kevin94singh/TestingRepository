import Stevia
import UIKit

final class StoriesViewController: BaseViewController<StoriesViewModel> {
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
        collectionView.register(StoriesCollectionViewCell.self)
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
    
    weak var delegate: StoriesViewControllerDelegate?
    
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
        setDefaultAttributesFor(style: .main, for: self, title: Localizable.storiesTitle())
    }
    
    @objc
    private func avatarTapped() {
        guard let user = viewModel.storiesData.value?.data.first?.user else { return } //same user always
        delegate?.storiesViewControllerDelegateShowUser(detail: user)
    }
}

extension StoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.storiesData.value?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StoriesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let data = viewModel.storiesData.value?.data.first?.user?.collections, data.count > 0 else { return cell }
        cell.set(collection: data[indexPath.row])
        return cell
    }
}

extension StoriesViewController: UICollectionViewDelegateFlowLayout {
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

extension StoriesViewController {
    func bindAction() {
        viewModel.storiesData
            .asDriver()
            .drive(onNext: { [weak self] (data) in
                guard let data = data else { return }
                self?.collectionView.reloadData()
                if let user = data.data.first?.user { /// User in API is still same
                    self?.avatarImageView.setImage(urlString: user.avatarImageUrl, placeholder: nil)
                    self?.usernameLabel.text(user.displayName ?? "")
                }
            }).disposed(by: disposeBag)
        
        viewModel
            .isExecuting
            .asDriver()
            .drive(rx.customLoading)
            .disposed(by: disposeBag)
        
        viewModel.error
            .asDriver()
            .drive(onNext: { [weak self] (error) in
                guard let error = error as? CustomError else { return }
                self?.showToast(message: error.customDescription.1)
            }).disposed(by: disposeBag)
    }
}
