
import UIKit
import AppTrackingTransparency

class DelegatSceny: UIResponder, UIWindowSceneDelegate {

    var okno: UIWindow?

    func scene(_ scena: UIScene, willConnectTo sesja: UISceneSession, options opcjePolaczenia: UIScene.ConnectionOptions) {
        guard let scenaOkna = (scena as? UIWindowScene) else { return }
        
        okno = UIWindow(windowScene: scenaOkna)
        
        let podrozPowitalna = PodrozPowitalna()
        let kontrolerNawigacji = UINavigationController(rootViewController: podrozPowitalna)
        kontrolerNawigacji.navigationBar.isHidden = true
        kontrolerNawigacji.view.backgroundColor = .black  // 设置导航控制器背景色避免闪烁
        
        okno?.rootViewController = kontrolerNawigacji
        okno?.backgroundColor = .black  // 设置窗口背景色避免闪烁
        okno?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scena: UIScene) {
    }

    func sceneDidBecomeActive(_ scena: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
    }

    func sceneWillResignActive(_ scena: UIScene) {
    }

    func sceneWillEnterForeground(_ scena: UIScene) {
    }

    func sceneDidEnterBackground(_ scena: UIScene) {
        (UIApplication.shared.delegate as? DelegatAplikacji)?.zapiszKontekst()
    }
}
