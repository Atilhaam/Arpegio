//
//  SearchNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 27/10/22.
//

import Foundation
import AsyncDisplayKit

class SearchNode: ASDisplayNode {
    
    var bar: UISearchBar? {
        return self.view as? UISearchBar
    }
    
    init(height: CGFloat) {
        super.init()
        self.setViewBlock({
            let searchView: UISearchBar = .init(frame: .zero)
            searchView.placeholder = "Search.."
            searchView.backgroundImage = nil
            searchView.backgroundColor = .clear
            searchView.searchBarStyle = .minimal
            return searchView
        })
        self.style.height = .init(unit: .points, value: height)
        self.backgroundColor = .white
    }
}
