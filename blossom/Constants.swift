//
//  Constants.swift
//  blossom
//
//  Created by Seong Phil on 2016. 10. 18..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation

struct BuildSettings {
    static let apiUrl = "API_URL"
}

struct Config {

}

struct PrefKey {
    static let id = "user_id"
    static let accessToken = "user_access_token"
    static let username = "username"
    static let sessionTypes = "session_types"
    static let profileId = "profile_id"
}

let apiUrl = (Bundle.main.object(forInfoDictionaryKey: BuildSettings.apiUrl) as? String)!

struct Api {
    static let users = apiUrl + "/users"
    static let session = apiUrl + "/session"
    static let posts = apiUrl + "/posts"
    static let sessionEmail = apiUrl + "/session/email"
    static let post = apiUrl + "/post"
    static let colorSize = apiUrl + "/color_sizes"
    static let hashtag = apiUrl + "/hashtags"
    static let follow = apiUrl + "/follow"
    static let likedPosts = apiUrl + "/liked_posts"
    static let followingStores = apiUrl + "/following_stores"
    static let like = apiUrl + "/like"
    static let userPosts = apiUrl + "/user_posts"
}

struct CellIdentity {
    static let mainSellCell = "MainSellCell"
    static let mainBuyCell = "MainBuyCell"
    static let mainReviewCell = "MainReviewCell"
    static let mainStoreCell = "MainStoreCell"
}

struct Font {
    static let graun = "Graun"
}

struct SegueIdentity {
    // MARK: Jump
    static let jumpToSignin = "jumpToSignin"
    static let jumpToUpload = "jumpToUpload"
    static let mainSellToDetail = "mainSellToDetail"
    static let mainToProfile = "mainToProfile"
    
    // MARK: Embed
    static let embedVideoViewController = "EmbedVideoViewController"
    
    // MARK: Unwind
    static let unwindFromProfile = "UnwindFromProfile"
}

struct StoryboardName {
    static let mainViewController = "MainViewController"
    static let profileViewController = "ProfileViewController"
}

struct StoryboardId {
    // MARK: ViewController
    static let mainViewController = "MainViewController"
    
    // MARK: Cell
    static let importVideoCell = "ImportVideoCell"
}

struct Regex {
    static let email = "[^@]+@[^@]+\\.[^@]+"
    static let username = "^[a-zA-Z0-9_]{3,15}$"
}

struct LoginType {
    static let fb = "fb"
    static let google = "google"
    static let email = "email"
}

struct EventName {
    static let topicPageChanged = "topicPageChanged"
}

struct ImageName {
    static let btnCancel = "btn_cancel"
    static let unhappy = "unhappy"
}

struct VideoError {
    static let success = 0

}

struct Exceptions {
    static let variableRequired = "VariableRequired"
}

struct HelpUrl {
    static let communityRuleUrl = URL(string: "http://treasureisle.co/rules")!
}

struct MixpanelToken {
    static let release = "b495b2413999e0de4bc3d12a7602e8d4"
    static let dev = "29f7a277fcf06e14fd41e60e1799d844"
}

struct MixpanelTrack {
    static let firstExecution = "firstExecution"
    static let session = "session"
    static let personalTotalSession = "personalTotalSession"
}
