//
//  TableViewCell.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/03.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var menuBarLabel: UILabel!
    @IBOutlet var View: UIView!
    @IBOutlet weak var menuBarImageView: UIImageView!
    @IBOutlet var explanationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menuBarLabel.adjustsFontSizeToFitWidth = true
        menuBarLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        menuBarImageView.contentMode = .scaleAspectFit
        View.layer.cornerRadius = 8
//        View.backgroundColor = UIColor(red: 178/255, green: 129/255, blue: 224/255, alpha: 0.8)
        View.backgroundColor = #colorLiteral(red: 0.8363565803, green: 0.6981750727, blue: 1, alpha: 1)
        
        View.layer.masksToBounds = true
        explanationLabel.adjustsFontSizeToFitWidth = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
