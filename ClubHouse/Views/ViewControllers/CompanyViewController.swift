//
//  ViewController.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD

class CompanyViewController: UIViewController {

    @IBOutlet weak var _tableView: UITableView!
    
    private lazy var viewModel: CompanyViewModelProtocol = {
        let _viewModel = CompanyViewModel(bind: self)
        return _viewModel
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(relaodData), for: .valueChanged)
        return refresh
    }()
    
    private var loading: Bool = false {
        didSet {
            invoke(onThread: DispatchQueue.main) { [weak self] in
                guard let _weakSelf = self else { return }
                
                if !SVProgressHUD.isVisible() && _weakSelf.loading == false { return }
                
                _weakSelf.loading ? SVProgressHUD.show():SVProgressHUD.dismiss()
                _weakSelf.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = _weakSelf.loading
            }
        }
    }
    
    private let segue_id = "DetailViewControllerSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        viewModel.fetchData()
    }
}

fileprivate extension CompanyViewController {
    func configureViews() {
        _tableView.tableFooterView = UIView()
        _tableView.addSubview(refreshControl)
    }
    
    @objc func relaodData() {
        guard loading == false else { return }
        
        invoke(after: 0.1) { [unowned self] in
            self.viewModel.fetchData(force: true)
        }
    }
    
    @objc func search(_ txt: String) {
        viewModel.filter = txt
    }
    
    func showAlert(_ msg: String) {
        let alert = UIAlertController(title: "ERROR", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension CompanyViewController: CompanyViewControllerDelegate {
    func willStartFetchingData() {
        loading = true
    }
    
    func didFinishFetchingData() {
        loading = false
        invoke(onThread: DispatchQueue.main) { [unowned self] in
            self._tableView.reloadData()
        }
    }
    
    func didFailedWithError(_ description: String) {
        loading = false
        invoke(onThread: DispatchQueue.main) { [unowned self] in
            self.showAlert(description)
        }
    }
}

extension CompanyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.companyCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let companyCell = tableView.dequeueReusableCell(withIdentifier: CompanyCell.identifier, for: indexPath) as! CompanyCell
        companyCell.company = viewModel.company(at: indexPath.item)
        return companyCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let company = viewModel.company(at: indexPath.item) else {
            return
        }
    }
}

extension CompanyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: textSearched)
        self.perform(#selector(search), with: textSearched, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
