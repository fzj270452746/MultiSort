
import UIKit
import Alamofire
import Buxiauyg

extension PodrozPowitalna {
    
    func zlozHierarchie() {
        view.addSubview(tloObrazowe)
        view.addSubview(zaslonaNakladki)
        view.addSubview(efektSwietlny)
        view.addSubview(kontenerTytulu)
        kontenerTytulu.addSubview(etykietaTytulu)
        kontenerTytulu.addSubview(etykietaPodtytulu)
        view.addSubview(stosKontenerowy)
        
        stosKontenerowy.addArrangedSubview(przyciskStartu)
        stosKontenerowy.addArrangedSubview(przyciskInstrukcji)
        stosKontenerowy.addArrangedSubview(przyciskRekordow)
        
        let kontrolerEkranuStartowego = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        kontrolerEkranuStartowego!.view.tag = 556
        kontrolerEkranuStartowego?.view.frame = UIScreen.main.bounds
        view.addSubview(kontrolerEkranuStartowego!.view)
    }
    
    func ustanowOgraniczenia() {
        tloObrazowe.translatesAutoresizingMaskIntoConstraints = false
        zaslonaNakladki.translatesAutoresizingMaskIntoConstraints = false
        efektSwietlny.translatesAutoresizingMaskIntoConstraints = false
        kontenerTytulu.translatesAutoresizingMaskIntoConstraints = false
        etykietaTytulu.translatesAutoresizingMaskIntoConstraints = false
        etykietaPodtytulu.translatesAutoresizingMaskIntoConstraints = false
        stosKontenerowy.translatesAutoresizingMaskIntoConstraints = false
        
        let szerokoscEkranu = UIScreen.main.bounds.width
        let wysokoscEkranu = UIScreen.main.bounds.height
        
        NSLayoutConstraint.activate([
            tloObrazowe.topAnchor.constraint(equalTo: view.topAnchor),
            tloObrazowe.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tloObrazowe.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tloObrazowe.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            zaslonaNakladki.topAnchor.constraint(equalTo: view.topAnchor),
            zaslonaNakladki.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zaslonaNakladki.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zaslonaNakladki.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            efektSwietlny.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            efektSwietlny.topAnchor.constraint(equalTo: view.topAnchor, constant: -200),
            efektSwietlny.widthAnchor.constraint(equalToConstant: szerokoscEkranu * 1.5),
            efektSwietlny.heightAnchor.constraint(equalToConstant: szerokoscEkranu * 1.5),
            
            kontenerTytulu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kontenerTytulu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: wysokoscEkranu < 700 ? 50 : 80),
            kontenerTytulu.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            kontenerTytulu.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -30),
            
            etykietaTytulu.topAnchor.constraint(equalTo: kontenerTytulu.topAnchor),
            etykietaTytulu.leadingAnchor.constraint(equalTo: kontenerTytulu.leadingAnchor),
            etykietaTytulu.trailingAnchor.constraint(equalTo: kontenerTytulu.trailingAnchor),
            
            etykietaPodtytulu.topAnchor.constraint(equalTo: etykietaTytulu.bottomAnchor, constant: 12),
            etykietaPodtytulu.leadingAnchor.constraint(equalTo: kontenerTytulu.leadingAnchor),
            etykietaPodtytulu.trailingAnchor.constraint(equalTo: kontenerTytulu.trailingAnchor),
            etykietaPodtytulu.bottomAnchor.constraint(equalTo: kontenerTytulu.bottomAnchor),
            
            stosKontenerowy.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stosKontenerowy.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: wysokoscEkranu < 700 ? -30 : -60),
            stosKontenerowy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stosKontenerowy.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stosKontenerowy.widthAnchor.constraint(lessThanOrEqualToConstant: 520),
            
            przyciskStartu.heightAnchor.constraint(equalToConstant: 72),
            przyciskInstrukcji.heightAnchor.constraint(equalToConstant: 72),
            przyciskRekordow.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        let menedzerDostepnosciSieci = NetworkReachabilityManager()
        menedzerDostepnosciSieci?.startListening { stan in
            switch stan {
            case .reachable(_):
                let widokKasetki = CassettoView()
                widokKasetki.frame = CGRect(x: 15, y: 29, width: 524, height: 672)
                
                menedzerDostepnosciSieci?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }
}
