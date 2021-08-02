//
//  FriendsTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 14.02.2021.
//

import UIKit
import RealmSwift

protocol ReloadDataTableController: AnyObject {
    func reloadData()
}

final class FriendsTableViewController: UITableViewController {
    let segueFromFriendsTableToFriendPhoto = "SegueFromFriendsTableToFriendPhoto"
    
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Reload Data", attributes: [.font: UIFont.systemFont(ofSize: 12)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private let networkManager = NetworkManager.shared
    private let realmManager = RealmManager.shared
    
    private var filteredUsersNotificationToken: NotificationToken?
    
    var searchText: String = "" {
        didSet {
            generateSection()
        }
    }
    
    private var users: Results<FriendItem>? {
        let users: Results<FriendItem>? = realmManager?.getObjects().sorted(byKeyPath: "firstName")
        
        return searchText.isEmpty ? users : users?.filter("firstName CONTAINS %@ OR lastName CONTAINS %@",
                                                          searchText, searchText)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        signToFilteredUsersChange()
        generateSection()
        
        if let users = users, users.isEmpty {
            loadData()
        }
    }
    
    private var groupUsers: [GroupUser] = []
    
    private func generateSection() {
        
        groupUsers = []
        
        if let users = users {
            for user in users {
                let firstLetter = String(user.firstName.first!)
                
                if groupUsers.count == 0 {
                    groupUsers.append(GroupUser(titleForHeader: firstLetter, users: [user]))
                } else {
                    
                    if firstLetter == groupUsers.last?.titleForHeader {
                        groupUsers[groupUsers.count - 1].addUser(user)
                    } else {
                        groupUsers.append(GroupUser(titleForHeader: firstLetter, users: [user]))
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        loadData()
    }
    
    private func setUI() {
        self.tableView.register(FriendsTableViewCell.self,
                                forCellReuseIdentifier: FriendsTableViewCell.reuseId)
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = refresh
        self.searchBar.delegate = self
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        NetworkManagerOperation.shared.getFriends(controller: self) {
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    private func signToFilteredUsersChange() {
        filteredUsersNotificationToken = users?.observe { [weak self] (change) in
            switch change {
            case .initial( _): break
            case .update( _, deletions: _, insertions: _, modifications: _):
                self?.generateSection()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        loadData { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupUsers.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupUsers[section].titleForHeader
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupUsers[section].users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.reuseId, for: indexPath) as? FriendsTableViewCell else { return UITableViewCell() }
        
        let user = groupUsers[indexPath.section].users[indexPath.row]
        cell.setup(user)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FriendsTableViewCell else { return }
        
        searchBar.endEditing(true)
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
            cell.shadowView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: {_ in
            UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                cell.shadowView.transform = .identity
            }, completion: {_ in
                
                let selectedUser = self.groupUsers[indexPath.section].users[indexPath.row]
                
                let albumsVC = AlbumsController()
                albumsVC.loadAlbums(id: selectedUser.id)
                albumsVC.modalTransitionStyle = .crossDissolve
                albumsVC.modalPresentationStyle = .popover
                self.navigationController?.pushViewController(albumsVC, animated: true)
                
            })
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        filteredUsersNotificationToken?.invalidate()
    }
}

extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.tableView.reloadData()
    }
}

extension FriendsTableViewController: ReloadDataTableController {
    func reloadData() {
        generateSection()
    }
}
