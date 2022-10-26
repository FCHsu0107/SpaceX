import UIKit

extension UIStackView {
    private func replaceSubviews(with views: [UIView]) {
        for subview in arrangedSubviews {
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        for subview in views {
            addArrangedSubview(subview)
        }
    }

    @discardableResult
    func containing(_ arrangedSubviews: [UIView]) -> Self {
        replaceSubviews(with: arrangedSubviews)
        return self
    }

    func configured(
        axis: NSLayoutConstraint.Axis? = nil,
        alignment: UIStackView.Alignment? = nil,
        distribution: UIStackView.Distribution? = nil
    ) -> Self {
        axis.map { self.axis = $0 }
        alignment.map { self.alignment = $0 }
        distribution.map { self.distribution = $0 }
        return self
    }
}
