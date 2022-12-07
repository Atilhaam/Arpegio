//
//  StoryModel.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 25/10/22.
//

import Foundation
public struct StoryModel {
    public let userAvatar: String
    public let userName: String
}
public struct PostModel {
    public let userName: String
    public let userAvatar: String
    public let location: String?
    public let image: String
    public let likesCount: Int
    public let caption: String
}
