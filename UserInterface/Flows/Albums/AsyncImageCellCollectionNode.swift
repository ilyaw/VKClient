//
//  AsyncImageCellCollectionNode.swift
//  UserInterface
//
//  Created by Ilya on 19.06.2021.
//

import AsyncDisplayKit

class AsyncImageCellCollectionNode: ASCellNode {
    let imageNode = ASImageNode()
    
    private var url: String?
    
    required init(with url: String) {
        super.init()
            
        imageNode.backgroundColor = .systemBackground
        imageNode.contentMode = .scaleAspectFill
        self.url = url
        self.addSubnode(self.imageNode)
    }
    
    func loadImage() {
        if let url = url {
            PhotoService.shared.photo(urlString: url)
                .done { [weak self] image in self?.imageNode.image = image }
                .catch { print($0.localizedDescription) }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageNodeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let imageNodeLayout = ASInsetLayoutSpec(insets: imageNodeInsets, child: imageNode)
        return imageNodeLayout
    }
}
