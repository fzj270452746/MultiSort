
import Foundation

struct PamiatkaGry: Codable {
    let znacznikCzasu: Date
    let uplywajaceSekundy: Int
    let osiagnietyWynik: Int
    let byloIdealne: Bool
    let identyfikatorWariantu: String
    let sladRuchu: Int?
    let czasRezydualny: Int?
    let uzytoPrzewijania: Bool?
    
    enum KluczeKodowania: String, CodingKey {
        case znacznikCzasu
        case uplywajaceSekundy
        case osiagnietyWynik
        case byloIdealne
        case identyfikatorWariantu
        case sladRuchu
        case czasRezydualny
        case uzytoPrzewijania
    }
    
    init(znacznikCzasu: Date, uplywajaceSekundy: Int, osiagnietyWynik: Int, byloIdealne: Bool, identyfikatorWariantu: String, sladRuchu: Int?, czasRezydualny: Int?, uzytoPrzewijania: Bool?) {
        self.znacznikCzasu = znacznikCzasu
        self.uplywajaceSekundy = uplywajaceSekundy
        self.osiagnietyWynik = osiagnietyWynik
        self.byloIdealne = byloIdealne
        self.identyfikatorWariantu = identyfikatorWariantu
        self.sladRuchu = sladRuchu
        self.czasRezydualny = czasRezydualny
        self.uzytoPrzewijania = uzytoPrzewijania
    }
    
    init(from dekoder: Decoder) throws {
        let kontener = try dekoder.container(keyedBy: KluczeKodowania.self)
        znacznikCzasu = try kontener.decode(Date.self, forKey: .znacznikCzasu)
        uplywajaceSekundy = try kontener.decode(Int.self, forKey: .uplywajaceSekundy)
        osiagnietyWynik = try kontener.decode(Int.self, forKey: .osiagnietyWynik)
        byloIdealne = try kontener.decode(Bool.self, forKey: .byloIdealne)
        identyfikatorWariantu = try kontener.decodeIfPresent(String.self, forKey: .identyfikatorWariantu) ?? WariantGry.klasycznyPrzeplyw.identyfikator
        sladRuchu = try kontener.decodeIfPresent(Int.self, forKey: .sladRuchu)
        czasRezydualny = try kontener.decodeIfPresent(Int.self, forKey: .czasRezydualny)
        uzytoPrzewijania = try kontener.decodeIfPresent(Bool.self, forKey: .uzytoPrzewijania)
    }
    
    func encode(to enkoder: Encoder) throws {
        var kontener = enkoder.container(keyedBy: KluczeKodowania.self)
        try kontener.encode(znacznikCzasu, forKey: .znacznikCzasu)
        try kontener.encode(uplywajaceSekundy, forKey: .uplywajaceSekundy)
        try kontener.encode(osiagnietyWynik, forKey: .osiagnietyWynik)
        try kontener.encode(byloIdealne, forKey: .byloIdealne)
        try kontener.encode(identyfikatorWariantu, forKey: .identyfikatorWariantu)
        try kontener.encodeIfPresent(sladRuchu, forKey: .sladRuchu)
        try kontener.encodeIfPresent(czasRezydualny, forKey: .czasRezydualny)
        try kontener.encodeIfPresent(uzytoPrzewijania, forKey: .uzytoPrzewijania)
    }
    
    var sformatowanyCzasTrwania: String {
        let minuty = uplywajaceSekundy / 60
        let sekundy = uplywajaceSekundy % 60
        return String(format: "%02d:%02d", minuty, sekundy)
    }
    
    var sformatowanaData: String {
        let formatujnik = DateFormatter()
        formatujnik.dateStyle = .medium
        formatujnik.timeStyle = .short
        return formatujnik.string(from: znacznikCzasu)
    }
    
    var nazwaWyswietlanaWariantu: String {
        WariantGry.wariant(dla: identyfikatorWariantu).nazwaWyswietlana
    }
    
    var sformatowanyCzasRezydualny: String? {
        guard let czasRezydualny = czasRezydualny else { return nil }
        let minuty = czasRezydualny / 60
        let sekundy = czasRezydualny % 60
        return String(format: "%02d:%02d", minuty, sekundy)
    }
}

class ArchiwumWynikow {
    static let singleton = ArchiwumWynikow()
    
    private let kluczPamiatki = StaleZywotne.KluczeMagazynu.rekordyGry
    
    private init() {}
    
    func zachowajPamiatke(_ pamiatka: PamiatkaGry) {
        var pamiatki = pobierzPamiatki()
        pamiatki.append(pamiatka)
        pamiatki.sort { $0.osiagnietyWynik > $1.osiagnietyWynik }
        
        if let zakodowane = try? JSONEncoder().encode(pamiatki) {
            UserDefaults.standard.set(zakodowane, forKey: kluczPamiatki)
        }
    }
    
    func pobierzPamiatki() -> [PamiatkaGry] {
        guard let dane = UserDefaults.standard.data(forKey: kluczPamiatki),
              let zdekodowane = try? JSONDecoder().decode([PamiatkaGry].self, from: dane) else {
            return []
        }
        return zdekodowane
    }
    
    func usunWszystkiePamiatki() {
        UserDefaults.standard.removeObject(forKey: kluczPamiatki)
    }
}
