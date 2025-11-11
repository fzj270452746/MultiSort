
import UIKit
import CoreData

@main
class DelegatAplikacji: UIResponder, UIApplicationDelegate {

    func application(_ aplikacja: UIApplication, didFinishLaunchingWithOptions opcjeUruchomienia: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ aplikacja: UIApplication, configurationForConnecting sesjaSceny: UISceneSession, options opcje: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: sesjaSceny.role)
    }

    func application(_ aplikacja: UIApplication, didDiscardSceneSessions odrzuconeSesje: Set<UISceneSession>) {
    }

    lazy var kontenerTrwaly: NSPersistentContainer = {
        let kontener = NSPersistentContainer(name: "MultiSort")
        kontener.loadPersistentStores(completionHandler: { (opisSklepu, blad) in
            if let blad = blad as NSError? {
                fatalError("Unresolved error \(blad), \(blad.userInfo)")
            }
        })
        return kontener
    }()

    func zapiszKontekst() {
        let kontekst = kontenerTrwaly.viewContext
        guard kontekst.hasChanges else { return }
        do {
            try kontekst.save()
        } catch {
            let bladNSError = error as NSError
            fatalError("Unresolved error \(bladNSError), \(bladNSError.userInfo)")
        }
    }
}
