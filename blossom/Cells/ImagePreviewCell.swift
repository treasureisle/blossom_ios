//
//  ImagePreviewCell.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 15..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit

class ImagePreviewCell: UICollectionViewCell {
    @IBOutlet weak var imageView:UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
