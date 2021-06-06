//
//  FriendPhotoCollectionViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit

class FriendPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setup(_ photo: PhotoItem) {
        
        //TODO: изменить получение фото после редизайна collection
        if let url = photo.sizes.first?.url {
            PhotoService.shared.photo(urlString: url)
                .done { [weak self] image in self?.photoImageView.image = image }
                .catch { print($0.localizedDescription) }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoImageView.image = nil
    }
}
