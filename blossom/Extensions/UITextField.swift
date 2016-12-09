//
//  UITextField.swift
//  blossom
//
//  Created by Seong Phil on 2016. 10. 18..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit

extension UITextField {
    // border 를 기본 텍스트필드 모양으로 변경
    func setDefaultBorder(){
        self.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
    
    func setAccentBorder(){
        self.layer.borderColor = UIColor(htmlColor: GluviColor.accentColor).cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 0.0
    }
    
    func setTransBorder(){
        self.layer.borderWidth = 0
    }
    
    func isValidUsername(_ container: UIViewController) -> Bool{
        let username = self.text!
        
        if username.characters.count < 4{
            // 너무 짧음 표시
            container.view.makeErrorToast(message: NSLocalizedString("USERNAME_IS_TOO_SHORT", comment: "유저네임이 너무 짧을 경우"))
            self.setAccentBorder()
            
            return false
        }
        
        if username.characters.count > 15 {
            // 너무 김 표시
            container.view.makeErrorToast(message: NSLocalizedString("USERNAME_IS_TOO_LONG", comment: "유저네임이 너무 길 경우"))
            self.setAccentBorder()
            
            return false
        }
        
        if !username.isMatch(Regex.username){
            // 유저네임 유효성 검사
            container.view.makeErrorToast(message: NSLocalizedString("USERNAME_IS_NOT_VALID", comment: "유저네임 형식에 어긋났을 경우"))
            self.setAccentBorder()
            
            return false
        }
        
        return true
    }
    
    func isValidComment(_ container: UIViewController) -> Bool{
        let comment = self.text!
        
        if comment.characters.count < 1{
            // 너무 짧음 표시
            container.view.makeErrorToast(message: NSLocalizedString("COMMENT_IS_TOO_SHORT", comment: "댓글이 너무 짧을 경우"))
            
            return false
        }
        
        if comment.characters.count > 100 {
            // 너무 김 표시
            container.view.makeErrorToast(message: NSLocalizedString("COMMENT_IS_TOO_LONG", comment: "댓글이 너무 길 경우"))
            
            return false
        }
        
        return true
    }
}

