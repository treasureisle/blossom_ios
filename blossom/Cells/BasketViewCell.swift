//
//  MessageViewCell.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 21..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation

import UIKit

class BasketViewCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var colorSizeNamesTextField: UITextField!
    @IBOutlet weak var colorSizeAmountTextField: UITextField!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    var colorSizeNamesDownPicker: DownPicker!
    var colorSizeAmountDownPicker: DownPicker!
    var colorSizes = [ColorSize]()
    var colorSizeNames = [String]()
    var colorSizeAvailable = [String]()
    var selectedColorSize: ColorSize!
    var selectedAmount: Int = 0
    
    func setSelectedFunc(){
        self.colorSizeNamesDownPicker.addTarget(self, action: #selector(self.colorSizeNameSelected(dp:)), for: .valueChanged)
    }
    
    func colorSizeNameSelected(dp: Any?) {
        self.colorSizeAmountTextField.isUserInteractionEnabled = true
        let selectedValue = self.colorSizeNamesDownPicker.text
        // do what you want
        self.colorSizeAvailable.removeAll()
        
        for colorSize in self.colorSizes {
            if colorSize.name == selectedValue {
                self.selectedColorSize = colorSize
                for i in (1..<colorSize.available){
                    self.colorSizeAvailable.append(String(i))
                }
                break
            }
        }
        
        self.colorSizeAmountDownPicker = DownPicker(textField: self.colorSizeAmountTextField, withData: self.colorSizeAvailable)
        self.colorSizeAmountDownPicker.addTarget(self, action: #selector(self.amountSelected(dp:)), for: .valueChanged)
    }
    
    func amountSelected(dp: Any?) {
        self.selectedAmount = Int(self.colorSizeAmountDownPicker.text)!
    }
}
