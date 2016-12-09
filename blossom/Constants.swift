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
    static let maxBitrate = 1900000 // 최대 비트레이트
    static let minRecordDuration = 2 // 최소 녹화시간 (2초)
    static let maxRecordDuration = 8 // 최대 녹화시간 (8초)
    static let next_topic_row = 16 // 한 번에 response되는 next topic 줄 수 - api의 NEXT_TOPIC_ROW와 맞춰야 함
    static let videoPageRow = 20 // All 리스트에서 페이지당 비디오 갯수
    static let mainFadeInDuration = 0.3 // 토픽이 나오고 사라질때 나머지 뷰 페이드인 시간(초)
    static let mainFadeOutDuration = 0.3 // 토픽이 나오고 사라질때 나머지 뷰 페이드아웃 시간(초)
    static let mainMenuThrowOutDuration = 0.3 // 메뉴 사라질때 나가는 시간 (초)
    static let mainMenuThrowInDuration = 0.3 // 메뉴 나올때 들어오는 시간 (초)
    static let topicPeriod = 14 // 토픽 지속기간 (일수)
    static let maxTopicCount = 100 // 토픽 최대 글자 수
    static let pickedTopicCount = 2 // 한 주에 선정되는 토픽 수
    static let remainedTopicCount = 10 // 다음 주까지 이월되는 next topic 수(picked 포함)
    static let best5Count = 5 // 베스트5 비디오 갯수
    static let remainTempFiles = 5 // 템프 비디오 파일 생성시 이전 최신 temp video 파일 남길 갯수
}

struct PrefKey {
    static let id = "user_id"
    static let accessToken = "user_access_token"
    static let username = "username"
    static let sessionTypes = "session_types"
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
    
    // MARK: Embed
    static let embedVideoViewController = "EmbedVideoViewController"
    
    // MARK: Unwind
    static let unwindFromProfile = "UnwindFromProfile"
}

struct StoryboardName {
    static let mainViewController = "MainViewController"
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

struct GluviColor {
    static let primaryColor = 0x4caf50
    static let darkPrimaryColor = 0x388e3c
    static let lightPrimaryColor = 0xc8e6c9
    static let accentColor = 0xff5722
    static let darkAccentColor = 0xe64a19
    static let plainTextColor = 0xfefefe
    
    static let topicColor = [0x00c76c, 0x038fdc, 0xfec224, 0xb64fc4]
    
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
