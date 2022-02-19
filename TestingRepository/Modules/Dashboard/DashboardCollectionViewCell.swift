import Stevia
import UIKit

final class DashboardCollectionViewCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel.white(font: .systemFont(ofSize: 20, weight: .bold))
        return label
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.alpha = 0.6
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        backgroundColor = .blue
        
        sv(
            backgroundImageView,
            overlayView,
            titleLabel
        )
        
        overlayView.fillContainer()
        backgroundImageView.fillContainer()
        titleLabel.top(30).left(30)
    }
    
    func set(collection: Collection) {
        if let name = collection.name {
            titleLabel.text(name)
        }
        if let color = collection.coverImageBg {
            overlayView.backgroundColor = UIColor(color)
        }
        backgroundImageView.setImage(urlString: collection.coverImageUrl, placeholder: UIImage(named: "placeholder-background"))
    }
}
