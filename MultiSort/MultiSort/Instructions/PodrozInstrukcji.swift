//
//  PodrozInstrukcji.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class PodrozInstrukcji: UIViewController {
    
    let wizerunekTla = UIImageView()
    let zaslonaNakladki = UIView()
    let przyciskPowrotu = UIButton(type: .system)
    let etykietaTytulu = UILabel()
    let naczyniePrzewijania = UIScrollView()
    let kontenerZawartosci = UIView()
    let tekstInstrukcji = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black  // 设置背景色避免白色闪烁
        
        zlozHierarchie()
        skonfigurujWyglad()
        ustanowOgraniczenia()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)  // 使用 false 避免闪烁
    }
}

