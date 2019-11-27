//
//  MemberViewController.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit
import PopoverKit
import RxSwift
import RxCocoa

class MemberViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        bindDependencies()
    }
}

fileprivate extension MemberViewController {
    func configureView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        tableView.tableFooterView = UIView()
    }
    
    func bindDependencies() {
        // bind title
        viewModel.title.bind(to: self.rx.title).disposed(by: viewModel.disposeBag)
        
        // sort button type
        viewModel.sortBy
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] option in
                self?.sortLabel.text = "\(option.caption)"
            }).disposed(by: viewModel.disposeBag)
        
        // table view cell binding
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: MemberCell.identifier)) { _, member, cell in
                guard let memberCell = cell as? MemberCell else { return }
                memberCell.member = member
        }.disposed(by: viewModel.disposeBag)
        
        // search bar filter
        searchBar.rx
            .text
            .orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.query)
            .disposed(by: viewModel.disposeBag)
        
        // search bar done clicked
        searchBar.rx
            .searchButtonClicked
            .subscribe { [weak self] clicked in
                self?.searchBar.resignFirstResponder()
        }.disposed(by: viewModel.disposeBag)
    }
    
    @objc func showSortOptions(_ gesture: UITapGestureRecognizer) {
        popover.pop.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(popover, animated: true, completion: nil)
    }
}

// MARK: - PopoverTableViewControllerDelegate
extension MemberViewController: PopoverTableViewControllerDelegate {
    func didSelectRow(at indexPath: IndexPath, in vc: PopoverTableViewController) {
        popover.dismiss(animated: true) { [weak self] in
            let selected = SortOptions.member[indexPath.item]
            guard selected != self?.viewModel.sortBy.value else {
                return
            }
            self?.viewModel.sortBy.accept(selected)
        }
    }
}
