//
//  MyGroupsTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit
import RealmSwift
import SDWebImage

class MyGroupsTableViewController: UITableViewController {
    let myGroups = "MyGroups"
    
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Reload Data", attributes: [.font: UIFont.systemFont(ofSize: 12)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        loadData { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    private let networkManager = NetworkManagerPromise.shared
    private let realmManager = RealmManager.shared
    
    private var groupsNotificationToken: NotificationToken?
    
    private var groups: Results<GroupItem>? {
        let groups: Results<GroupItem>? = realmManager?.getObjects()
        return groups
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = refresh
        
        signToGroupsChanges()
        loadData()
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.getGroups(on: .main)
            .get { [weak self] groups in
                let sortedGroups = groups.sorted { $0.id < $1.id }
                let arrEqual = sortedGroups == self?.groups?.toArray()
                
                if !arrEqual {
                    try? self?.realmManager?.add(objects: sortedGroups)
                }
            }
            .catch { [weak self] error in
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
            .finally {
                completion?()
            }
    }
    
    private func signToGroupsChanges() {
        groupsNotificationToken = groups?.observe { [weak self] (changes) in
            switch changes {
            case .initial( _): break
            case .update( _, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self?.tableView.beginUpdates()
                
                let deletionsIndexPaths = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPaths = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPaths = modifications.map { IndexPath(row: $0, section: 0) }
                
                self?.tableView.deleteRows(at: deletionsIndexPaths, with: .automatic)
                self?.tableView.insertRows(at: insertionsIndexPaths, with: .automatic)
                self?.tableView.reloadRows(at: modificationsIndexPaths, with: .automatic)
                
                self?.tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: myGroups, for: indexPath) as? MyGroupsTableViewCell else {
            return UITableViewCell()
        }
        
        guard let group = groups?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.groupName.text = group.name
        
        if let url = URL(string: group.photo50) {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    cell.avatar.sd_setImage(with: url)
                }
            }
        }
        
        return cell
    }
    
    deinit {
        groupsNotificationToken?.invalidate()
    }
}
