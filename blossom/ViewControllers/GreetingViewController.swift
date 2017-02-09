//
//  GreetingViewController.swift
//  blossom
//
//  Created by Seong Phil on 2017. 2. 9..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import Foundation
import UIKit

class GreetingViewController: UIViewController {
    @IBOutlet weak var scGender: UISegmentedControl!
    @IBOutlet weak var textFieldAge: UITextField!
    
    @IBAction func saveTouched(){
        var age = 20
        var categoryId = 0
        if textFieldAge.text!.isEmpty {
            return
        } else {
            age = Int(textFieldAge.text!)!
        }
        
        switch scGender.selectedSegmentIndex {
        case 0: //male
            categoryId = 1 // 남성
            if age < 20 {
                categoryId = 3 // 남성,10대
            } else if age < 25 {
                categoryId = 4 // 남성,20대초반
            } else if age < 30 {
                categoryId = 5 // 남성,20대후반
            } else if age < 35 {
                categoryId = 6 // 남성,30대초반
            } else if age < 40 {
                categoryId = 7 // 남성,30대후반
            } else {
                categoryId = 8 // 남성,40대이상
            }
            break
        case 1: //femail
            categoryId = 2 // 여성
            if age < 20 {
                categoryId = 9 // 여성,10대
            } else if age < 25 {
                categoryId = 10 // 여성,20대초반
            } else if age < 30 {
                categoryId = 11 // 여성,20대후반
            } else if age < 35 {
                categoryId = 12 // 여성,30대초반
            } else if age < 40 {
                categoryId = 13 // 여성,30대후반
            } else {
                categoryId = 14 // 여성,40대이상
            }
            break
        default:
            break;
        }
        
        Category.saveMyCategory(categoryId: categoryId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
