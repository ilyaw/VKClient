//
//  AlbumsController.swift
//  UserInterface
//
//  Created by Ilya on 19.06.2021.
//

import Foundation
import AsyncDisplayKit

class AlbumsController: ASDKViewController<ASTableNode> {
    
    // Создаем дополнительный интерфейс для обращения к корневой ноде
    var tableNode: ASTableNode {
        return node
    }
    
    private let networkManager = NetworkManager.shared
    let id: Int = 0
    var albums = [AlbumItem]()
    
    override init() {
        super.init(node: ASTableNode())
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.allowsSelection = false
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        self.navigationItem.title = "Альбомы"
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    func loadAlbums(id: Int) {
        networkManager.getAlbums(userId: id) { [weak self] (result) in
            switch result {
            case let .success(albums):
                DispatchQueue.main.async {
                    self?.albums = albums
                    self?.tableNode.reloadData()
                }
            case let .failure(error):
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlbumsController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return albums.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let album = albums[indexPath.section]
        
        let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
            let photoCollection = PhotoCollection()
            photoCollection.album = album
            photoCollection.loadPhotosFromAlbum()
            return photoCollection
        }, didLoad: nil)
        
        let size = CGSize(width: tableNode.bounds.size.width, height: tableNode.bounds.size.height/2)
        node.style.preferredSize = size
        
        return {
            return node
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return albums[section].title
    }
}

