import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        setUpMainWindow()
    }

    private func setUpMainWindow() {
        let vc = UINavigationController(rootViewController: CompanyViewController())
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

