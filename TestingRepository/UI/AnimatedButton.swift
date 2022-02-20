import UIKit

class AnimatedButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.93, y: 0.93) : .identity
            animate(transform)
        }
    }
}

private extension AnimatedButton {
    private func animate(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
            self.transform = transform
        })
    }
}

extension AnimatedButton {
    static func clearMain(font: UIFont? = .systemFont(ofSize: 17, weight: .regular)) -> AnimatedButton {
        let button = button(backgroundColor: .clear)
        button.backgroundColor = .clear
        button.titleLabel?.font = font
        return button
    }
}

extension AnimatedButton {
    static private func button(backgroundColor: UIColor) -> AnimatedButton {
        let button = AnimatedButton()
        button.backgroundColor = backgroundColor
        return button
    }
}
