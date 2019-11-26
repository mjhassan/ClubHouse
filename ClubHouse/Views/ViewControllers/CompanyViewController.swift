//
//  ViewController.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController {

    private lazy var viewModel: CompanyViewModelProtocol = {
        let _viewModel = CompanyViewModel(bind: self)
        return _viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension CompanyViewController: CompanyViewControllerDelegate {
    func willStartFetchingData() {
        
    }
    
    func didFinishFetchingData() {
        
    }
    
    func didFailedWithError(_ description: String) {
        
    }
}
