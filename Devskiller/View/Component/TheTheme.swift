import UIKit

enum FontType {
    case pageTitle
    case title
    case paragraph
    case secondary
    case tertiary
    
    var size: CGFloat {
        switch self {
        case .pageTitle: return 34
        case .title, .paragraph: return 17
        case .secondary: return 15
        case .tertiary: return 13
        }
    }
    
    var weight: UIFont.Weight {
        switch self {
        case .pageTitle: return .bold
        case .title, .paragraph, .secondary, .tertiary: return .regular
        }
    }
    
    var color: UIColor {
        switch self {
        case .pageTitle, .title: return UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        case .paragraph: return UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        case .secondary, .tertiary: return UIColor(red: 97 / 255, green: 97 / 255, blue: 97 / 255, alpha: 1.0)
        }
    }
}

class TT {
    
    // Inset
    static var sideInset: CGFloat = 12
    static var verticalInset: CGFloat = 8
    
    // Color
    static let shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    static let badgeBGColor = UIColor(red: 248 / 255, green: 207 / 255, blue: 54 / 255, alpha: 1.0)
    static let cellBgColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1.0)
    
    // Corner Radius
    static let badgeCornerRadius: CGFloat = 6
    static let cardCornerRadius: CGFloat = 5
    
    static func font(_ type: FontType) -> UIFont {
        UIFont.systemFont(ofSize: type.size, weight: type.weight)
    }
}
