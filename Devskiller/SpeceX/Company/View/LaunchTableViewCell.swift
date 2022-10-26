import UIKit

class LaunchTableViewCell: UITableViewCell {
    private lazy var missonPatchImageView = makeImageView()
    private let descriptionView = DescriptionView()
    private let stateView = MarkView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView().containing([missonPatchImageView, descriptionView, stateView])
            .configured(axis: .horizontal, alignment: .top, distribution: .fillProportionally)
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: TT.verticalInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -TT.verticalInset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TT.sideInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TT.sideInset),
            missonPatchImageView.heightAnchor.constraint(equalToConstant: 40),
            missonPatchImageView.widthAnchor.constraint(equalToConstant: 40),
            stateView.heightAnchor.constraint(equalToConstant: 20),
            stateView.widthAnchor.constraint(equalToConstant: 20),
        ])
        stateView.config(isSuccessful: true)
        
    }
    
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }
}

fileprivate class DescriptionView: UIStackView {
    private lazy var missionLabel = makeValueLabel()
    private lazy var dateLabel = makeValueLabel()
    private lazy var rocketLabel = makeValueLabel()
    private lazy var daysValueLabel = makeValueLabel()
    private lazy var daysKeyLabel = makeKeyLabel("Days since now:")
    
    lazy var keyLabels = [
        makeKeyLabel("Misson:"),
        makeKeyLabel("Date/time:"),
        makeKeyLabel("Rocket:"),
        daysKeyLabel
    ]
    
    lazy var valueLabels = [
        missionLabel,
        dateLabel,
        rocketLabel,
        daysValueLabel
    ]
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .brown
        let keyView = UIStackView().containing(keyLabels).configured(axis: .vertical)
        keyView.backgroundColor = .orange
        let valueView = UIStackView().containing(valueLabels).configured(axis: .vertical)
        containing([keyView, valueView])
        axis = .horizontal
        distribution = .fillProportionally
    }

    private func makeKeyLabel(_ key: String) -> UILabel {
        let label = UILabel()
        label.textColor = .gray
        label.text = key
        label.backgroundColor = .green
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }
    
    private func makeValueLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.text = "BBBBBhhhhhhhhhhh"
        label.backgroundColor = .yellow
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }
}

fileprivate class MarkView: UIImageView {
    enum State {
        case successful
        case unsuccessful
        
        var imageName: String {
            switch self {
            case .successful: return "checkmark"
            case .unsuccessful: return "xmark"
            }
        }
    }
    
    func config(isSuccessful: Bool) {
        let state: State = isSuccessful ? .successful : .unsuccessful
        image = UIImage(systemName: state.imageName)
    }
}
