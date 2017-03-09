//
//  SettingViewController.swift
//  blossom
//
//  Created by Seong Phil on 2017. 3. 7..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UITableViewController {
    @IBOutlet weak var alramMessageSwitch: UISwitch!
    @IBOutlet weak var alramReplySwitch: UISwitch!
    @IBOutlet weak var alramFeedSwitch: UISwitch!
    @IBOutlet weak var loginKakaoSwitch: UISwitch!
    @IBOutlet weak var loginFacebookSwitch: UISwitch!
    @IBOutlet weak var loginInstagramSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 배송정보 변경
            performSegue(withIdentifier: SegueIdentity.settingToAddress, sender: self)
            break
        case 2: // 메세지 알림
            alert()
            break
        case 3: // 댓글 알림
            alert()
            break
        case 4: // 피드 알림
            alert()
            break
        case 6: // 카카오톡 로그인
            alert()
            break
        case 7: // Facebook 로그인
            break
        case 8: // Instagram 로그인
            break
        case 10: // 이용약관
            performSegue(withIdentifier: SegueIdentity.settingToWebview, sender: WebUrl.communityRuleUrl)
            break
        case 11: // 개인정보보호정책
            performSegue(withIdentifier: SegueIdentity.settingToWebview, sender: WebUrl.termOfUseUrl)
            break
        case 12: // 도움말
            performSegue(withIdentifier: SegueIdentity.settingToWebview, sender: WebUrl.helpUrl)
            break
        case 13: // 로그아웃
            logout()
            break
        case 15: // 탈퇴요청
            deleteAccount()
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.settingToWebview {
            
        }
    }
    
    @IBAction func cancleTouched() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alramFeedSwitchValueChanged(_ sender: Any) {
        alert()
        if alramFeedSwitch.isOn {
            
        }
        else {
            alramFeedSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func alramMessageSwitchValueChanged(_ sender: Any) {
        alert()
        if alramMessageSwitch.isOn {
            
        }
        else {
            alramMessageSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func alramReplySwitchValueChanged(_ sender: Any) {
        alert()
        if alramReplySwitch.isOn {
            
        }
        else {
            alramReplySwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func loginKakaoSwitchValueChanged(_ sender: Any) {
        alert()
        if loginKakaoSwitch.isOn {
            
        }
        else {
            loginKakaoSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func loginFacebookSwitchValueChanged(_ sender: Any) {
        alert()
        if loginFacebookSwitch.isOn {
            
        }
        else {
            loginFacebookSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func loginInstagramSwitchValueChanged(_ sender: Any) {
        alert()
        if loginInstagramSwitch.isOn {
            
        }
        else {
            loginInstagramSwitch.setOn(false, animated: true)
        }
    }
    
    func alert() {
        let alert = BlossomAlertController(message: "아직 지원하지 않는 기능입니다.")
        alert.addAction(action: BlossomAlertAction(title: "OK", style: .Positive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logout() {
        let alert = BlossomAlertController(message: "로그아웃 하시겠습니까?")
        alert.addAction(action: BlossomAlertAction(title: "Cancel", style: .Positive, handler: nil))
        alert.addAction(action: BlossomAlertAction(title: "Yes", style: .Negative, handler: {
            action in
            Session.remove()
            
            let alert = BlossomAlertController(message: "로그아웃 되었습니다. 처음 페이지로 돌아갑니다.")
            alert.addAction(action: BlossomAlertAction(title: "OK", style: .Positive, handler: {
                action in
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.resetWindowToInitView()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteAccount() {
        let alert = BlossomAlertController(message: "탈퇴 요청은 약 1주일 정도 소요됩니다. 정말 탈퇴하시겠습니까?")
        alert.addAction(action: BlossomAlertAction(title: "Cancel", style: .Positive, handler: nil))
        alert.addAction(action: BlossomAlertAction(title: "Yes", style: .Negative, handler: {
            action in
            Session.remove()
            let alert = BlossomAlertController(message: "로그아웃 되었습니다. 처음 페이지로 돌아갑니다.")
            alert.addAction(action: BlossomAlertAction(title: "OK", style: .Positive, handler: {
                action in
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.resetWindowToInitView()
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

