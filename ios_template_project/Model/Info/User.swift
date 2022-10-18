//
//  UserInfo.swift
//  ios_template_project
//
//  Created by Hien Pham on 10/25/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit

struct User: Codable {
    let id: Int
    let iconURL: String
    let nickname: String
    let userDescription: String
    let webSite: String
    let birthDay: String
    let apay: Int
    let followerCount: Int
    let followeeCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case iconURL = "icon_url"
        case nickname
        case userDescription = "description"
        case webSite = "web_site"
        case birthDay = "birth_day"
        case apay
        case followerCount = "follower_count"
        case followeeCount = "followee_count"
    }
}
