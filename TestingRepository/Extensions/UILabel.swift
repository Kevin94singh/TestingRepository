import Foundation
import UIKit

extension UILabel {
    static func white(font: UIFont? = .systemFont(ofSize: 17, weight: .regular)) -> UILabel {
        let label = label(textColor: .white)
        label.font = font
        return label
    }
    
    static func black(font: UIFont? = .systemFont(ofSize: 17, weight: .regular)) -> UILabel {
        let label = label(textColor: .black)
        label.font = font
        return label
    }
}

extension UILabel {
    static private func label(textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        return label
    }
}
