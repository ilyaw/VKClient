//
//  FriendsTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 14.02.2021.
//

import UIKit
import RealmSwift
import SDWebImage
import FirebaseFirestore

final class FriendsTableViewController: UITableViewController {
    let segueFromFriendsTableToFriendPhoto = "SegueFromFriendsTableToFriendPhoto"
    let friendCell = "FriendCell"
    
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Reload Data", attributes: [.font: UIFont.systemFont(ofSize: 12)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    var userCollection = Firestore.firestore().collection("Users")
    var listener: ListenerRegistration?
    private var usersTest = [FirebaseUser]()
    
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
        
        if let users = users, users.isEmpty {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = refresh
        self.searchBar.delegate = self
        
        filteredUsers = users
        
        listener = userCollection.addSnapshotListener { [weak self] (snapshot, error) in
            //удаляем все старые данные
            self?.usersTest.removeAll()
            
            //все документы
            guard let snapshot = snapshot,
                  !snapshot.documents.isEmpty
            else {
                self?.loadData()
                return
            }
            
            //если что-то есть
            for document in snapshot.documents {
                guard
                    let user = FirebaseUser(dict: document.data())
                else { continue }
                
                self?.usersTest.append(user)
            }
            
            //     self?.usersTableView.reloadData()
        }
        
        signToFilteredUsersChange()
        loadData()
    }
    
    private func signToFilteredUsersChange() {
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
    
    
    class MyFriend: Codable {
        let id: Int
        let name: String
        
        init(_ id: Int,
             _ name: String) {
            self.id = id
            self.name = name
        }
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.getFriends { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let friends):
                DispatchQueue.main.async {
                    
//                    let firebaseUsers = friends.map { FirebaseUser.init(from: $0) }
//                    for user in firebaseUsers {
//                        //  создаем новую ветку
//                        
//                       // self?.saveUserToFirestore(user: user)
//                     
//                    
//                        self?.userCollection.document("\(Session.shared.userId)").setData([
//                            "friends": [MyFriend(1, "Vasya"), MyFriend(2, "Pasha")],
//                             
////                            "firstName": "Ilya",
////                            "lastName": "Rudenko",
////
////                            "friends": [
////                                [
////                                    "id": 1,
////                                    "firstName": "Pavel",
////                                    "lastName": "Durov",
////                                    "photo_50": "url"
////                                ],
////                                [
////                                    "id": 2,
////                                    "firstName": "Test",
////                                    "lastName": "Qweqwe",
////                                    "photo_50": "url"
////                                ]
////                            ],
////
////                            "groups": [
////                                "id": 1,
////                                "title": "This is group",
////                                "photo_50": "url"
////                            ]
//                            
//                        ], merge: true) { [weak self] (error) in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            }
//                        }
//                        
//                    }
                    
                    
                    
                    
                    
                    let sortedFriends = friends.sorted { $0.id < $1.id }
                    let arrEqual = sortedFriends == self?.users?.toArray()
                    
                    if !arrEqual {
                        try? self?.realmManager?.add(objects: friends)
                    }
                    
                    completion?()
                }
            }
        }
    }
    
    private func saveUserToFirestore(user: FirebaseUser) {
        userCollection.document("\(user.id)").setData(user.toAnyObject()) { [weak self] (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return filteredData[section].firstLetter
    //    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendCell, for: indexPath) as? FriendsTableViewCell else {
            return UITableViewCell()
        }
        
        if let user = self.filteredUsers?[indexPath.row] {
            cell.name.text = user.firstName + " " + user.lastName
            if let url = URL(string: user.photo50 ?? "") {
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        cell.shadowView.avatar.sd_setImage(with: url)
                    }
                }
            }
        }
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
                self.performSegue(withIdentifier: self.segueFromFriendsTableToFriendPhoto, sender: self)
            })
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == self.segueFromFriendsTableToFriendPhoto else {
            return
        }
        
        guard let source = segue.source as? FriendsTableViewController else {
            return
        }
        
        guard let destination = segue.destination as? FriendPhotoCollectionViewController else {
            return
        }
        
        if let index = source.tableView.indexPathForSelectedRow {
            destination.user = filteredUsers?[index.row]
        }
    }
    
    deinit {
        //        filteredUsersNotificationToken?.invalidate()
        listener?.remove()
    }
}

extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = searchText.isEmpty ? users : users?.filter("firstName CONTAINS %@ OR lastName CONTAINS %@", searchText, searchText)
        self.tableView.reloadData()
    }
}


//extension FriendsTableViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        var tempData: [GroupUser] = []
//
//        if searchText == "" {
//            filteredData = FriendsTableViewController.groupUsers
//        } else {
//            for group in FriendsTableViewController.groupUsers {
//
//                let filteredUsers = group.users.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
//
//                if filteredUsers.count > 0 {
//                    tempData.append(GroupUser(firstLetter: group.firstLetter, users: filteredUsers))
//                }
//            }
//
//            filteredData = tempData
//        }
//
//        self.tableView.reloadData()
//    }
//}


//extension FriendsTableViewController: UINavigationControllerDelegate {
//
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        return AnimatorOpen()
//    }
//}