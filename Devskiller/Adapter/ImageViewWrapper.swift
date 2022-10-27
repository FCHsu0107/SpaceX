import UIKit
import Kingfisher

extension UIImageView {
    func set(_ urlString: String?, placeholder: UIImage? = nil) {
        guard let string = urlString else { return }
        self.kf.setImage(with: URL(string: string), placeholder: placeholder)
    }
}
