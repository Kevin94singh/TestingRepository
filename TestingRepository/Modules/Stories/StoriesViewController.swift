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
    
    private lazy var userInfoButton: UserInfoButton = {
        let button = UserInfoButton()
        return button
    }()
    
    weak var delegate: StoriesViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.sv(
            collectionView,
            userInfoButton
        )
        
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        userInfoButton.Bottom == collectionView.Bottom - 40
        userInfoButton.right(30)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDataAction.execute()
    }
    
    // MARK: - Bind
    
    override func bind() {
        super.bind()
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGradientBackground()
    }
    
    // MARK: - Style
    
    override func setStyle() {
        super.setStyle()
        setDefaultAttributesFor(style: .main, for: self, title: Localizable.storiesTitle())
    }
    
    private func setGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(1).cgColor,
            UIColor.black.withAlphaComponent(1).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor
        ]
        gradient.locations = [0, 0.03, 0.8, 1]
        view.layer.mask = gradient
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
        userInfoButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let user = self?.viewModel.storiesData.value?.data.first?.user else { return } /// same user always
                self?.delegate?.storiesViewControllerDelegateShowUser(detail: user)
            }).disposed(by: disposeBag)
        
        viewModel.storiesData
            .asDriver()
            .drive(onNext: { [weak self] (data) in
                guard let data = data else { return }
                self?.collectionView.reloadData()
                if let user = data.data.first?.user { /// User in API is still same
                    self?.userInfoButton.set(image: user.avatarImageUrl, name: user.displayName)
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
