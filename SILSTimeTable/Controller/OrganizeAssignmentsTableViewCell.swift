//
//  OrganizeAssignmentsTableViewCell.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/11/22.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class OrganizeAssignmentsTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var todoImage: UIImageView!
    @IBOutlet var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 8
        view.backgroundColor = #colorLiteral(red: 0.8526435494, green: 0.7645041347, blue: 1, alpha: 1)
        view.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
