//
//  PhotoCollection.swift
//  UserInterface
//
//  Created by Ilya on 19.06.2021.
//

import AsyncDisplayKit
import UIKit

class PhotoCollection: ASDKViewController<ASCollectionNode> {
    var album: AlbumItem?
    
    private var photos: [PhotoItem] = []
    private var collectionNode: ASCollectionNode
    private let networkManager = NetworkManager.shared
    
    override init() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.height / 4
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(node: collectionNode)
        
        collectionNode.backgroundColor = .systemBackground
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = album?.title
        collectionNode.view.isScrollEnabled = true
    }
    
    func loadPhotosFromAlbum() {
        guard let album = album,
              let ownerId = album.ownerID,
              let albumId = album.id else { return }
        
        // -9000 - альбом "фото с другом", парсится отдельным апи методом
        if albumId == -9000 {
            getUserPhotos(ownerId: ownerId)
        } else {
            getPhotos(ownerId: ownerId, albumId: albumId)
        }
    }
    
    private func getUserPhotos(ownerId: Int) {
        networkManager.getUserPhotos(ownerId: ownerId) { [weak self] result in
            switch result {
            case let .success(photos):
                DispatchQueue.main.async {
                    self?.photos = photos
                    self?.collectionNode.reloadData()
                }
            case let .failure(error):
                print(error)
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
        }
    }
    
    private func getPhotos(ownerId: Int, albumId: Int) {
        networkManager.getPhotos(ownerId: ownerId, albumId: albumId) { [weak self] result in
            switch result {
            case let .success(photos):
                DispatchQueue.main.async {
                    self?.photos = photos
                    self?.collectionNode.reloadData()
                }
            case let .failure(error):
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
        }
    }
}

extension PhotoCollection: ASCollectionDataSource, ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let vc = FriendsPhotoViewController(photos: photos, currentIndex: indexPath.row) 
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let photo = photos[indexPath.row]
        
        let imageSize = photo.sizes.first {
            size in size.type == .q
        } ?? photo.sizes.last
        
        if let imageSize = imageSize {
            return { AsyncImageCellCollectionNode(with: imageSize.url) }
        }
        
        return { ASCellNode() }
    }
    
    func collectionView(_ collectionView: ASCollectionView, willDisplay node: ASCellNode, forItemAt indexPath: IndexPath) {
        guard let node = node as? AsyncImageCellCollectionNode else { return }
        
        node.loadImage()
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
}
