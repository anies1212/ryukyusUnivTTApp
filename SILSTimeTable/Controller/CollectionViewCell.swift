//
//  CollectionViewCell.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/05/31.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    
    
    @IBOutlet weak var subjectsLabel: UILabel!
    @IBOutlet weak var classRoomPlaceLabel: UILabel!
    var whereRow:Int!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        
        subjectsLabel.frame = CGRect(x: 4.5, y: 5, width: 40, height: 40)
//        subjectsLabel.textAlignment = NSTextAlignment.center
        let font = UIFont(name: "AppleColorEmoji", size: 8)
        subjectsLabel.font = font
        subjectsLabel.adjustsFontSizeToFitWidth = true
        
        classRoomPlaceLabel.frame = CGRect(x: 4.5, y: 50, width: 38, height: 10)
        classRoomPlaceLabel.textAlignment = NSTextAlignment.center
        let font2 = UIFont(name: "ArialMT", size: 7.5)
        classRoomPlaceLabel.font = font2
        classRoomPlaceLabel.textColor = .white
        classRoomPlaceLabel.layer.cornerRadius = 3
        classRoomPlaceLabel.clipsToBounds = true
        classRoomPlaceLabel.adjustsFontSizeToFitWidth = true
        
        self.layer.borderWidth = 0.0
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = UIColor.gray.cgColor
    
        subjectsLabel.text = String()
        classRoomPlaceLabel.text = String()
        
        //影をつける
        // add shadow on cell
        self.backgroundColor = .clear // very important
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.05
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)


        
        
    }
    
    
    
    
}
