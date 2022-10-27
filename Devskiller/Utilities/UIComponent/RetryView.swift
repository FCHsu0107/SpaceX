import UIKit

final class RetryView: UIView {
    private let message: String
    private let retry: () -> Void
    
    public init(message: String, retry: @escaping () -> Void) {
        self.message = message
        self.retry = retry
        super.init(frame: .zero)
        backgroundColor = .yellow
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    
    private func setupContent() {
        backgroundColor = .white
        let subviews = [imageView, label, retryButton]
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2 * TT.verticalInset),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            retryButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2 * TT.verticalInset),
            retryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            retryButton.heightAnchor.constraint(equalToConstant: 32),
            retryButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle")
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reload", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = message
        label.textAlignment = .center
        return label
    }()
    
    @objc private func buttonDidClick() {
        retry()
    }
}
