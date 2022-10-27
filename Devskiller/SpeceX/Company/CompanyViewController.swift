import UIKit

final class CompanyViewController: UIViewController {
    private let viewModel: CompanyViewModelProtocol
    
    private lazy var tableView: UITableView = initTableView()
    
    init(viewModel: CompanyViewModelProtocol = CompanyViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.data.bind { _ in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setUpUI() {
        navigationItem.title = "SpeceX"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        addNavigationItem()
    }
    
    private func initTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(cellType: CompanyTableViewCell.self)
        tableView.register(cellType: LaunchTableViewCell.self)
        return tableView
    }
    
    private func addNavigationItem() {
        let filterItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(filterDidClick)
        )
        filterItem.tintColor = .black
        self.navigationItem.rightBarButtonItems = [filterItem]
    }
    
    @objc private func filterDidClick() {
        print("filter did click")
    }
}

extension CompanyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.data.value?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.value?.sections[section].Rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel.data.value?.sections[indexPath.section].Rows[indexPath.row] else {
            return CompanyTableViewCell()
        }
        switch item {
        case let .company(company):
            let cell = tableView.dequeueReusableCell(CompanyTableViewCell.self, for: indexPath)
            cell.config(company)
            return cell
        case let .launch(launch):
            let cell = tableView.dequeueReusableCell(LaunchTableViewCell.self, for: indexPath)
            cell.config(launch)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.data.value?.sections[section].title
    }
}
