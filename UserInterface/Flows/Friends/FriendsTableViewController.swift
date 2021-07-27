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
    
    private var filteredUsers: Results<FriendItem>!
    private var users: Results<FriendItem>? {
        let users: Results<FriendItem>? = realmManager?.getObjects()
        return users
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        signToFilteredUsersChange()
        
        if let users = users, users.isEmpty {
            loadData()
        }
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
        filteredUsers = users
        filteredUsersNotificationToken = filteredUsers?.observe { [weak self] (change) in
            switch change {
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
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        loadData { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.reuseId, for: indexPath) as? FriendsTableViewCell,
              let user = self.filteredUsers?[indexPath.row] else { return UITableViewCell() }
        
        cell.setup(user)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FriendsTableViewCell else { return }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
            cell.shadowView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: {_ in
            UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                cell.shadowView.transform = .identity
            }, completion: {_ in
                if let id = self.filteredUsers?[indexPath.row].id {
                    let albumsVC = AlbumsController()
                    albumsVC.loadAlbums(id: id)
                    albumsVC.modalTransitionStyle = .crossDissolve
                    albumsVC.modalPresentationStyle = .popover
                    self.navigationController?.pushViewController(albumsVC, animated: true)
                }
                //                self.performSegue(withIdentifier: self.segueFromFriendsTableToFriendPhoto, sender: self)
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == self.segueFromFriendsTableToFriendPhoto,
              let source = segue.source as? FriendsTableViewController,
              let destination = segue.destination as? FriendPhotoCollectionViewController else {
            return
        }
        
        if let index = source.tableView.indexPathForSelectedRow {
            destination.user = filteredUsers?[index.row]
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        filteredUsersNotificationToken?.invalidate()
    }
}

extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = searchText.isEmpty ? users : users?.filter("firstName CONTAINS %@ OR lastName CONTAINS %@", searchText, searchText)
        self.tableView.reloadData()
    }
}

extension FriendsTableViewController: ReloadDataTableController {
    func reloadData() {
        filteredUsers = users
    }
}