//
//  ViewController.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD
import PopoverKit
import RxSwift
import RxCocoa

class CompanyViewController: UIViewController {

    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private lazy var viewModel: CompanyViewModelProtocol = {
        let _viewModel = CompanyViewModel()
        return _viewModel
    }()
    
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
        let options = SortOptions.company.map { PureTitleModel(title: $0.caption) }
        let vc = PopoverTableViewController(items: options)
        vc.pop.isNeedPopover = true
        vc.pop.popoverPresentationController?.arrowPointY = navigationController?.navigationBar.frame.maxY
        vc.delegate = self
        return vc
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(relaodData), for: .valueChanged)
        return refresh
    }()
    
    private let segue_id = "MemberViewControllerSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        bindViews()
        
        viewModel.fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segue_id,
            let destination = segue.destination as? MemberViewController {
            destination.viewModel = MemberViewModel(sender as! Company)
        }
    }
}

fileprivate extension CompanyViewController {
    func configureViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        _tableView.tableFooterView = UIView()
        _tableView.addSubview(refreshControl)
    }
    
    @objc func relaodData() {
        invoke(after: 0.1) { [unowned self] in
            self.viewModel.fetchData(force: true)
        }
    }
    
    @objc func showSortOptions(_ gesture: UITapGestureRecognizer) {
        popover.pop.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(popover, animated: true, completion: nil)
    }
    
    func bindViews() {
        // Progress hud
        viewModel.loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.refreshControl.endRefreshing()
                loading ? SVProgressHUD.show():SVProgressHUD.dismiss()
                UIApplication.shared.isNetworkActivityIndicatorVisible = loading
            }).disposed(by: viewModel.disposeBag)
        
        // table view cell binding
        viewModel.list
            .bind(to: _tableView.rx.items(cellIdentifier: CompanyCell.identifier)) { _, company, cell in
                guard let companyCell = cell as? CompanyCell else { return }
                companyCell.company = company
        }.disposed(by: viewModel.disposeBag)
        
        // table view cell selection
        _tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let _ws = self else { return }
                _ws._tableView.deselectRow(at: indexPath, animated: true)
                
                guard let company = _ws.viewModel.company(at: indexPath.item) else { return }
                _ws.performSegue(withIdentifier: _ws.segue_id, sender: company)
        }).disposed(by: viewModel.disposeBag)
        
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
        
        // error binding
        viewModel.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] msg in
                guard let _ws = self else { return }
                
                let alert = UIAlertController(title: "ERROR", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                _ws.present(alert, animated: true, completion: nil)
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: - PopoverTableViewControllerDelegate
extension CompanyViewController: PopoverTableViewControllerDelegate {
    func didSelectRow(at indexPath: IndexPath, in vc: PopoverTableViewController) {
        popover.dismiss(animated: true) { [weak self] in
            guard let _ws = self else { return }
            
            let selected = SortOptions.company[indexPath.item]
            guard selected != _ws.viewModel.sortBy.value else {
                return
            }
            
            _ws.sortLabel.text = "\(selected.caption)"
            _ws.viewModel.sortBy.accept(selected)
        }
    }
}
