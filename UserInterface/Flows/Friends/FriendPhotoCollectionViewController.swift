//
//  FriendPhotoCollectionViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit
import RealmSwift

//class FriendPhotoCollectionViewController: UICollectionViewController {
//    let reuseIdentifier = "FriendPhoto"
//
//    var user: FriendItem!
//
//    private let networkManager = NetworkManager.shared
//    private let realmManager = RealmManager.shared
//
//    private var photosNotificationToken: NotificationToken?
//
//    private var photos: Results<PhotoItem>? {
//        let photos: Results<PhotoItem>? = realmManager?.getObjects()
//        return photos?.filter("ownerID = %@", user.id)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
//
//        loadData()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        signToFilteredUsersChanges()
//
//        if let photos = photos, photos.isEmpty {
//            loadData()
//        }
//    }
//
//    private func loadData() {
////        networkManager.getPhotos(ownerId: user.id,
////                                 albumId: .profile,
////                                 rev: .antiСhronological) { [weak self] (result) in
////            switch result {
////            case .failure(let error):
////                print(error.localizedDescription)
////            case .success(let photos):
////                DispatchQueue.main.async {
////                    let sortedPhotos = photos.sorted { $0.id < $1.id }
////                    let arrEqual = sortedPhotos == self?.photos?.toArray()
////
////                    if !arrEqual {
////                        try? self?.realmManager?.add(objects: photos)
////                       // let ownerID = self?.user.id ?? 0
////                       // self?.photos = try? self?.realmManager?.getObjects().filter("ownerID = %@", ownerID)
////                        self?.collectionView.reloadData()
////                    }
////                }
////            }
////        }
//    }
//
//    private func signToFilteredUsersChanges() {
//        photosNotificationToken = photos?.observe { [weak self] (change) in
//            switch change {
//            case .initial( _): break
//            case .update( _, deletions: let deletions, insertions: let insertions, modifications: let modifications):
//                let deletionsIndexPaths = deletions.map { IndexPath(row: $0, section: 0) }
//                let insertionsIndexPaths = insertions.map { IndexPath(row: $0, section: 0) }
//                let modificationsIndexPaths = modifications.map { IndexPath(row: $0, section: 0) }
//
//                self?.collectionView.performBatchUpdates({
//                    self?.collectionView.deleteItems(at: deletionsIndexPaths)
//                    self?.collectionView.insertItems(at: insertionsIndexPaths)
//                    self?.collectionView.reloadItems(at: modificationsIndexPaths)
//                }, completion: nil)
//
//            case.error(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.photos?.count ?? 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FriendPhotoCollectionViewCell,
//              let photo = self.photos?[indexPath.row] else { return UICollectionViewCell() }
//
//        cell.setup(photo)
//
//        return cell
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        photosNotificationToken?.invalidate()
//    }
//}
