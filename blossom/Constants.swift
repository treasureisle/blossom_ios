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
    static let postalApiKey = "U01TX0FVVEgyMDE3MDEyMDE0MTkxMjE4NDcx"
}

struct PrefKey {
    static let id = "user_id"
    static let accessToken = "user_access_token"
    static let username = "username"
    static let sessionTypes = "session_types"
    static let profileId = "profile_id"
    static let categories = "categories"
    static let myCategoryId = "my_category_id"
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
    static let isFollowing = apiUrl + "/is_following"
    static let feeds = apiUrl + "/feeds"
    static let searchUser = apiUrl + "/search_user"
    static let searchPost = apiUrl + "/search_post"
    static let reply = apiUrl + "/reply"
    static let replyLike = apiUrl + "/reply_like"
    static let basket = apiUrl + "/basket"
    static let purchase = apiUrl + "/purchase"
    static let messages = apiUrl + "/message"
    static let userDetail = apiUrl + "/user_detail"
    static let category = apiUrl + "/category"
    static let hashtagScore = apiUrl + "/hashtag_score"
    static let store = apiUrl + "/store"
    static let storeDetail = apiUrl + "/store_detail"
    
    static let postalSearch = "http://www.juso.go.kr/addrlink/addrLinkApiJsonp.do"
}

struct CellIdentity {
    static let mainCell = "MainCell"
    static let feedCell = "FeedCell"
    static let imagePreviewCell = "ImagePreviewCell"
    static let searchUsersCell = "SearchUsersCell"
    static let basketViewCell = "BasketViewCell"
    static let purchaseViewCell = "PurchaseViewCell"
    static let purchaseListViewCell = "PurchaseListViewCell"
    static let messageViewCell = "MessageViewCell"
    static let storeBannerCell = "StoreBannerCell"
}

struct Font {
    static let regular = "NanumBarunGothicOTF"
    static let bold = "NanumBarunGothicOTF Bold"
    static let light = "NanumBarunGothicOTF Light"
    static let ultraLight = "NanumBarunGothicOTF UltraLight"
}

struct SegueIdentity {
    // MARK: Jump
    static let jumpToSignin = "jumpToSignin"
    static let jumpToUpload = "jumpToUpload"
    static let mainToGreeting = "mainToGreeting"
    static let mainSellToDetail = "mainSellToDetail"
    static let mainBuyToDetail = "mainBuyToDetail"
    static let mainReviewToDetail = "mainReviewToDetail"
    static let mainStoreToDetail = "mainStoreToDetail"
    static let mainToProfile = "mainToProfile"
    static let mainToFeed = "mainToFeed"
    static let mainToSearchUsers = "mainToSearchUsers"
    static let mainToSearchPosts = "mainToSearchPosts"
    static let mainToCart = "mainToCart"
    static let detailToProfile = "detailToProfile"
    static let profileLikeToDetail = "profileLikeToDetail"
    static let profileListToDetail = "profileListToDetail"
    static let profileStoreToDetail = "profileStoreToDetail"
    static let profileToSetting = "profileToSetting"
    static let profileToPurchaseList = "profileToPurchaseList"
    static let feedToUpload = "feedToUpload"
    static let feedToProfile = "feedToProfile"
    static let feedToMain = "feedToMain"
    static let feedToSearchUsers = "feedToSearchUsers"
    static let feedToSearchPosts = "feedToSearchPosts"
    static let feedToCart = "feedToCart"
    static let searchUsersToProfile = "searchUsersToProfile"
    static let searchUsersToMain = "searchUsersToMain"
    static let searchUsersToFeed = "searchUsersToFeed"
    static let searchUsersToUpload = "searchUsersToProfile"
    static let searchUsersToSignIn = "searchUsersToSignIn"
    static let searchPostsToProfile = "searchPostsToProfile"
    static let searchPostsToMain = "searchPostsToMain"
    static let searchPostsToFeed = "searchPostsToFeed"
    static let searchPostsToUpload = "searchPostsToUpload"
    static let searchPostsToSignIn = "searchPostsToSignIn"
    static let searchPostsToDetail = "searchPostsToDetail"
    static let replyToProfile = "replyToProfile"
    static let replyToReply = "replyToReply"
    static let detailToReply = "detailToReply"
    static let feedSellToReply = "feedSellToReply"
    static let feedSellToDetail = "feedSellToDetail"
    static let feedSellToProfile = "feedSellToProfile"
    static let feedCommonToReply = "feedSCommonToReply"
    static let feedCommonToDetail = "feedCommonToDetail"
    static let feedCommonToProfile = "feedCommonToProfile"
    static let cartToDetail = "cartToDetail"
    static let cartToPurchase = "cartToPurchase"
    static let purchaseToDetail = "purchaseToDetail"
    static let purchaseToProfile = "purchaseToProfile"
    static let detailToCart = "detailToCart"
    static let messageToProfile = "messageToProfile"
    static let mainToSubStore = "mainToSubStore"
    static let subStoreToMain = "subStoreToMain"
    static let subStoreToFeed = "subStoreToFeed"
    static let subStoreToDetail = "subStoreToDetail"
    static let subStoreToUpload = "subStoreToUpload"
    static let subStoreToSignIn = "subStoreToSignIn"
    static let subStoreToProfile = "subStoreToProfile"
    static let subStoreToCart = "subStoreToCart"
    static let subStoreToSearchUsers = "subStoreToSearchUsers"
    static let subStoreToSearchPosts = "subStoreToSearchPosts"
    static let storeToDetail = "storeToDetail"
    static let storeToSubStore = "storeToSubStore"
    static let settingToAddress = "settingToAddress"
    static let settingToWebview = "settingToWebview"
    static let settingToMain = "settingToMain"
    
    static let test = "test"
    
    // MARK: Embed
    static let embedVideoViewController = "EmbedVideoViewController"
    
    // MARK: Unwind
    static let unwindFromProfile = "UnwindFromProfile"
}

struct StoryboardName {
    static let mainViewController = "MainViewController"
    static let profileViewController = "ProfileViewController"
    static let feedViewController = "FeedViewController"
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

struct Colors {
    static let shobit_pink = 0xc84e4c
}

struct ImageName {
    static let btnCancel = "btn_cancel"
    static let unhappy = "unhappy"
    static let imgHeartN = "btn_detail_preview_like_nor"
    static let imgHeart = "btn_detail_preview_like_sel"
    static let check_checked = "btn_productcheck_sel"
    static let check_unchecked = "btn_productcheck_nor"
    static let regions = ["대한민국","미국", "영국", "독일", "호주", "프랑스", "이탈리아", "일본", "스페인"]
    static let flags = [#imageLiteral(resourceName: "kr"), #imageLiteral(resourceName: "us"), #imageLiteral(resourceName: "uk"), #imageLiteral(resourceName: "de"), #imageLiteral(resourceName: "au"), #imageLiteral(resourceName: "fr"), #imageLiteral(resourceName: "it"), #imageLiteral(resourceName: "jp"), #imageLiteral(resourceName: "es")]
}

struct Exceptions {
    static let variableRequired = "VariableRequired"
}

struct WebUrl {
    static let termOfUseUrl = URL(string: "http://treasureisle.co")!
    static let communityRuleUrl = URL(string: "http://treasureisle.co")!
    static let helpUrl = URL(string: "http://treasureisle.co")!
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
