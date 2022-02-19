//
//  CalendarTableViewCell.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/09/18.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

protocol CalendarTableViewCellDelegate {
    func didTapCheckButton(button: UIButton, indexPath: IndexPath)
}

class CalendarTableViewCell: UITableViewCell {
    
    var delegate: CalendarTableViewCellDelegate?
    @IBOutlet var view: UIView!
    @IBOutlet var taskTitleLabel: UILabel!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var inputtedSubjectLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.taskTitleLabel.adjustsFontSizeToFitWidth = true
        self.deadlineLabel.adjustsFontSizeToFitWidth = true
        self.inputtedSubjectLabel.adjustsFontSizeToFitWidth = true
        
        let font4 = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        deadlineLabel.font = font4
        
//        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0.1, height: 0.1)).cgPath
        // add shadow on cell
        backgroundColor = .clear // very important
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0
//        layer.shadowRadius = 0.5
//        layer.shadowOffset = CGSize(width: 0.1, height: 0.1)
//        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
//        view.layer.cornerRadius = 8
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 0.5

        // add corner radius on `contentView`
        contentView.backgroundColor = .white
//        contentView.layer.cornerRadius = 8
        

//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    



}
