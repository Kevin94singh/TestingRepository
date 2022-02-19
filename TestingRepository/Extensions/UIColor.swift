import UIKit

extension UIColor {
    static let testingRepositoryError = UIColor("#E53E3E")
}

extension UIColor {
    convenience init(_ hexString: String) {
        var hexString = hexString
        
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }
        
        var rgbValue: UInt64 = 0
        
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue >> 16) & 0xff) / 255.0
        let green = CGFloat((rgbValue >> 08) & 0xff) / 255.0
        let blue = CGFloat((rgbValue >> 00) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
