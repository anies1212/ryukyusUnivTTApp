//
//  ToDoTableViewCell.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/07/07.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB

class ToDoTableViewCell: UITableViewCell {
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet var deadLineLabel: UILabel!
    @IBOutlet var inputtedSubjectLabel: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet var starButton: UIButton!
//    weak var cellDelegate: ToDoTableViewCellDelegate?
    @IBOutlet var checkMarkButton: UIButton!
    var delegate: ToDoTableViewCellDelegate?
    var checkState = false
    var cellIndex: IndexPath!
    var starCheckState = false
    var starCellIndex: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        starButton.setTitle("", for: .normal)
        starButton.setImage(UIImage(named: "emptyStar")?.withRenderingMode(.alwaysTemplate), for: .normal)
        starButton.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        checkMarkButton.setTitle("", for: .normal)
        checkMarkButton.setImage(UIImage(named: "iconUnchecked25")?.withRenderingMode(.alwaysTemplate), for: .normal)
        checkMarkButton.tintColor = UIColor(red: 178/255, green: 129/255, blue: 224/255, alpha: 1)
        self.toDoLabel.adjustsFontSizeToFitWidth = true
        self.deadLineLabel.adjustsFontSizeToFitWidth = true
        self.inputtedSubjectLabel.adjustsFontSizeToFitWidth = true
        
//        view.backgroundColor = #colorLiteral(red: 0.8363565803, green: 0.6981750727, blue: 1, alpha: 1)
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 1
//        view.layer.cornerRadius = 8
//        view.clipsToBounds = true
        
        let font3 = UIFont(name: "ArialMT", size: 15)
        toDoLabel.font = font3
        let font4 = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        deadLineLabel.font = font4
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10)).cgPath

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        buttonState(checkState, button: checkMarkButton)
        starButtonState(starCheckState, button: starButton)
    }
    
    struct ToDo {
        var title: String
        var done: Bool
    }
    
    // button
    func buttonState(_ state: Bool, button: UIButton) {
        switch state {
        case true:
            button.setTitle("", for: .normal)
            button.setImage(UIImage(named: "iconChecked25")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = #colorLiteral(red: 0.7725490196, green: 0.5411764706, blue: 1, alpha: 1)
        case false:
            button.setTitle("", for: .normal)
            button.setImage(UIImage(named: "iconUnchecked25")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = #colorLiteral(red: 0.7725490196, green: 0.5411764706, blue: 1, alpha: 1)
        }
    }
    
    // button
    func starButtonState(_ state: Bool, button: UIButton) {
        switch state {
        case true:
            button.setTitle("", for: .normal)
            button.setImage(UIImage(named: "filledStar")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case false:
            button.setTitle("", for: .normal)
            button.setImage(UIImage(named: "emptyStar")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
    }
    
    
    
    @IBAction func check(button: UIButton) {
        self.delegate?.didTapCheckButton(button: button, indexPath: cellIndex)
    }
    
    @IBAction func starCheck(button: UIButton) {
        self.delegate?.didTapStarCheckButton(button: button, indexPath: cellIndex)
    }
    
    
}

protocol ToDoTableViewCellDelegate {
    func didTapCheckButton(button: UIButton, indexPath: IndexPath)
    func didTapStarCheckButton(button: UIButton, indexPath: IndexPath)
}

//protocol ToDoTableViewCellDelegate {
//    func didTapStarCheckButton(button: UIButton, indexPath: IndexPath)
//}



