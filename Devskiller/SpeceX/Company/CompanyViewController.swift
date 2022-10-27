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
        tableView.register(cellType: UITableViewCell.self)
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
        showAlterView()
    }
    
    private func showAlterView() {
        let alert = UIAlertController(
            title: "Filter launch year",
            message: "Enter a specific year",
            preferredStyle: .alert
        )
        
        alert.addTextField { (textField) in
            textField.placeholder = "e.g. 2022"
        }

       
        alert.addAction(UIAlertAction(title: "ASC", style: .default, handler: { [weak self] (_) in
            guard let text = alert.textFields?[0].text, let year = Int(text) else { return }
            self?.viewModel.filterLaunchYear(year, isASE: true)
            
        }))
        alert.addAction(UIAlertAction(title: "DESC", style: .default, handler: { [weak self] (_) in
            guard let text = alert.textFields?[0].text, let year = Int(text) else { return }
            self?.viewModel.filterLaunchYear(year, isASE: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
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
            return UITableViewCell()
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
        case .empty:
            let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
            cell.textLabel?.text = "There is no launches in this conditions. Please filter another year"
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.data.value?.sections[section].title
    }
}
