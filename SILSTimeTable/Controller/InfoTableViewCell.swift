//
//  InfoTableViewCell.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/11/15.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import RKNotificationHub

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    var alreadyCheckedAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2;
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func alreadyCheckButtonAction(_ sender: Any){
        alreadyCheckedAction?()
    }
    
    
}
