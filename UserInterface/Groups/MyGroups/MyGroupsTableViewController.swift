//
//  MyGroupsTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit
import RealmSwift

class MyGroupsTableViewController: UITableViewController {
    
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Reload Data", attributes: [.font: UIFont.systemFont(ofSize: 12)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск по моим группам"
        searchBar.backgroundColor = .white
        searchBar.sizeToFit()
        return searchBar
    }()
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        loadData { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    private let networkManager = NetworkManagerPromise.shared
    private let realmManager = RealmManager.shared
    
    private var groupsNotificationToken: NotificationToken?
    
    private var filteredGroups: Results<GroupItem>!
    private var groups: Results<GroupItem>? {
        let groups: Results<GroupItem>? = realmManager?.getObjects()
        return groups
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        loadData()
    }
    
    private func setUI() {
        filteredGroups = groups
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        self.refreshControl = refresh
        
        self.tableView.register(MyGroupsTableViewCell.self, forCellReuseIdentifier: MyGroupsTableViewCell.reuseId)
        self.tableView.addSubview(searchBar)
        self.tableView.tableHeaderView = searchBar
        
        self.searchBar.delegate = self
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.getGroups(on: .global())
            .get(on: .main) { [weak self] groups in
                
                let sortedNetworkGroups = groups.sorted { $0.id < $1.id }
                let realmGroups = self?.groups?.toArray() ?? []
                let arrEqual = sortedNetworkGroups == realmGroups
                
                if !arrEqual {
                    try? self?.realmManager?.delete(objects: realmGroups)
                    try? self?.realmManager?.add(objects: sortedNetworkGroups)
                    self?.tableView.reloadData()
                }
            }
            .catch { [weak self] error in
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
            .finally(on: .main) {
                completion?()
            }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Выйти") { [weak self] (action, view, completion) in
            if let group = self?.filteredGroups?[indexPath.row] {
                self?.networkManager.removeGroup(groupId: String(group.id), on: .global())
                    .catch { [weak self] error in
                        self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
                    }
                    .finally { [weak self] in
                        try? self?.realmManager?.delete(object: group)
                        
                        let deletionsIndexPaths = [IndexPath(row: indexPath.row, section: indexPath.section)]
                        
                        DispatchQueue.main.async {
                            self?.tableView.beginUpdates()
                            self?.tableView.deleteRows(at: deletionsIndexPaths, with: .automatic)
                            self?.tableView.endUpdates()
                        }
                    }
            }
            completion(true)
        }
        
        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyGroupsTableViewCell.reuseId, for: indexPath) as? MyGroupsTableViewCell,
              let group = filteredGroups?[indexPath.row]  else {
            return UITableViewCell()
        }
        
        cell.setup(group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MyGroupsTableViewCell else { return }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
            cell.photoView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: {_ in
            UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                cell.photoView.transform = .identity
            }, completion: {_ in
                //self.performSegue(withIdentifier: self.segueFromFriendsTableToFriendPhoto, sender: self)
            })
        })
    }
    
    deinit {
        groupsNotificationToken?.invalidate()
    }
}

extension MyGroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredGroups = searchText.isEmpty ? groups : groups?.filter("name contains[cd] %@", searchText)
        
        self.tableView.reloadData()
    }
}
