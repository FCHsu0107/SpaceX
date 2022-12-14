import UIKit

final class LaunchTableViewCell: UITableViewCell {
    private let patchImageView = UIImageView()
    private let descriptionView = DescriptionView()
    private let stateView = MarkView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ launch: CompanyViewData.Launch) {
        descriptionView.config(launch)
        stateView.config(isSuccessful: launch.isSuccessful)
        patchImageView.set(launch.imageUrl, placeholder: UIImage(systemName: "questionmark"))
    }
    
    private func setupUI() {
        let stackView = UIStackView().containing([patchImageView, descriptionView, stateView])
            .configured(axis: .horizontal, alignment: .top, distribution: .fillProportionally)
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: TT.verticalInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -TT.verticalInset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TT.sideInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TT.sideInset),
            patchImageView.heightAnchor.constraint(equalToConstant: 40),
            patchImageView.widthAnchor.constraint(equalToConstant: 40),
            stateView.heightAnchor.constraint(equalToConstant: 24),
            stateView.widthAnchor.constraint(equalToConstant: 24),
        ])
        stateView.config(isSuccessful: true)
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
    
    func config(_ launch: CompanyViewData.Launch) {
        missionLabel.text = launch.mission
        dateLabel.text = launch.dateAndTime
        rocketLabel.text = launch.rocket
        daysKeyLabel.text = launch.daysKey
        daysValueLabel.text = launch.daysValue
    }
    
    private func setupUI() {
        let keyView = UIStackView().containing(keyLabels).configured(axis: .vertical)
        let valueView = UIStackView().containing(valueLabels).configured(axis: .vertical)
        containing([keyView, valueView])
        axis = .horizontal
        distribution = .fillProportionally
    }

    private func makeKeyLabel(_ key: String) -> UILabel {
        let label = UILabel()
        label.textColor = .gray
        label.text = key
        label.font = UIFont.systemFont(ofSize: 12)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }
    
    private func makeValueLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
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
        contentMode = .scaleAspectFit
        tintColor = isSuccessful ? .green : .red
    }
}
