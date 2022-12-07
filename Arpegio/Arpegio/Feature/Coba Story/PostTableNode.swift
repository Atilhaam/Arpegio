//
//  PostTableNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 14/11/22.
//

import Foundation
import AsyncDisplayKit

public final class PostTableNode: ASTableNode {
    
    private let posts: [PostModel]
    init(posts: [PostModel]) {
        self.posts = posts
        super.init(style: .plain)
        self.delegate = self
        self.dataSource = self
        self.style.width = .init(unit: .fraction, value: 1)
        self.style.flexGrow = 1
    }
    
    public override func didLoad() {
        super.didLoad()
        self.view.separatorStyle = .none
    }
}
extension PostTableNode: ASTableDelegate, ASTableDataSource {
    public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    
    public func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let postData = posts[indexPath.row]
        return {
            PostNode(post: postData)
        }
    }
}
