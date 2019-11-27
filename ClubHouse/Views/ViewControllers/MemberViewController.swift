//
//  MemberViewController.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit
import PopoverKit

class MemberViewController: UITableViewController {

    public var viewModel: MemberViewModelProtocol!
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "None"
        return label
    }()
    
    private lazy var sortButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        let label = UILabel()
        label.text = "Sort by: "
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .darkGray
        stackView.addArrangedSubview(label)
        
        stackView.addArrangedSubview(self.sortLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showSortOptions(_:)))
        stackView.addGestureRecognizer(tap)
        
        return stackView
    }()
    
    private lazy var popover: PopoverTableViewController = {
        let options = SortOptions.member.map { PureTitleModel(title: $0.caption) }
        let vc = PopoverTableViewController(items: options)
        vc.pop.isNeedPopover = true
        vc.pop.popoverPresentationController?.arrowPointY = navigationController?.navigationBar.frame.maxY
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindPassage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        tableView.tableFooterView = UIView()
    }
    
    @objc func search(_ txt: String) {
        viewModel.filter = txt
    }
    
    @objc func showSortOptions(_ gesture: UITapGestureRecognizer) {
        popover.pop.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(popover, animated: true, completion: nil)
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

// MARK: - Search bar delegate
extension MemberViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: textSearched)
        self.perform(#selector(search), with: textSearched, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - PopoverTableViewControllerDelegate
extension MemberViewController: PopoverTableViewControllerDelegate {
    func didSelectRow(at indexPath: IndexPath, in vc: PopoverTableViewController) {
        popover.dismiss(animated: true) { [weak self] in
            let selected = SortOptions.member[indexPath.item]
            guard selected != self?.viewModel.sortBy else {
                return
            }
            
            self?.sortLabel.text = "\(selected.caption)"
            self?.viewModel.sortBy = selected
        }
    }
}
