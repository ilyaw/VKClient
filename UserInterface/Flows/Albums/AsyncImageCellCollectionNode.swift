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
        DispatchQueue.global().async {
            if let url = self.url,
               let data = try? Data(contentsOf: URL(string: url)!),
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageNode.image = image
                }
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageNodeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let imageNodeLayout = ASInsetLayoutSpec(insets: imageNodeInsets, child: imageNode)
        return imageNodeLayout
    }
}
