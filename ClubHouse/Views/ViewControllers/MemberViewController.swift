//
//  MemberViewController.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class MemberViewController: UITableViewController {

    public var viewModel: MemberViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindPassage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureView()
        viewModel.reloadData()
    }
}

fileprivate extension MemberViewController {
    func bindPassage() {
        viewModel.dataUpdateClosure = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func configureView() {
        title = viewModel.title
        tableView.tableFooterView = UIView()
    }
    
    @objc func search(_ txt: String) {
        viewModel.filter = txt
    }
}

// MARK: - Table view data source
extension MemberViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.memberCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memberCell = tableView.dequeueReusableCell(withIdentifier: MemberCell.identifier, for: indexPath) as! MemberCell
        memberCell.member = viewModel.member(at: indexPath.item)
        return memberCell
    }
}

extension MemberViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: textSearched)
        self.perform(#selector(search), with: textSearched, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
