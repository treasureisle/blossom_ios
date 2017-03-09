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
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageStepper: UIStepper!
    
    var age = 30
    
    @IBAction func ageChanged(_ sender: Any) {
        age = Int(ageStepper.value)
        ageLabel.text = String(age)
    }
    
    @IBAction func saveTouched(){
        var categoryId = 0
        
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.resetWindowToInitView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageStepper.value = Double(age)
        ageLabel.text = String(age)
        
    }
    
    
}
