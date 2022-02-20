import Stevia
import UIKit

final class UserInfoButton: AnimatedButton {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel.white(font: .systemFont(ofSize: 17, weight: .regular))
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        sv(
            avatarImageView,
            usernameLabel
        )
        
        layout(
            0,
            |-0-avatarImageView.size(30)-10-usernameLabel-0-|,
            0
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: String?, name: String?) {
        avatarImageView.setImage(urlString: image, placeholder: nil)
        usernameLabel.text(name ?? "")
    }
}
