
import UIKit.UITableView

protocol ClassNameProtocol {
    
    static var className: String { get }
    
    var className: String { get }
}

extension ClassNameProtocol {
    
    static var className: String {
        
        return String(describing: self)
    }

    var className: String {
        
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}


extension UITableView {

     //cell
    func register(cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.className)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T else {
            
            return T()
        }
        return cell
    }

    // header footer
    func registerHeaderFooter(viewType: UITableViewHeaderFooterView.Type) {
        register(viewType, forHeaderFooterViewReuseIdentifier: viewType.className)
    }

    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: type.className) as? T else {
            return T()
        }
        return view
    }
}
