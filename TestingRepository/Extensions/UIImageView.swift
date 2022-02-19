import Kingfisher
import os.log
import UIKit

extension UIImageView {
    func setImage(urlString: String?, placeholder: UIImage? = nil, completion: (() -> Void)? = nil) {
        if let imageString = urlString, let imageUrl = URL(string: imageString) {
            self.kf.setImage(with: imageUrl, placeholder: placeholder, options: [], completionHandler:  { (result) in
                switch result {
                case .success(let data):
                    self.image = data.image
                    completion?()
                case .failure(let error):
                    os_log("Error while loding image: %@", type: .info, error.localizedDescription)
                    self.image = placeholder
                    completion?()
                }
            })
        } else {
            self.image = placeholder
            completion?()
        }
    }
}
