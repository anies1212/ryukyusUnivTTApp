//
//  SelectSubjectTableViewCell.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/05.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

protocol SelectSubjectTableViewCellDelegate  {
//    func didTapDetailButton(targetCell: UITableViewCell, targetButton: UIButton)
    func didTapDetailButton(button: UIButton, indexPath: IndexPath)
}

class SelectSubjectTableViewCell: UITableViewCell {
    
    var delegate: SelectSubjectTableViewCellDelegate?
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var dayTimeLabel: UILabel!
    @IBOutlet weak var profLabel: UILabel!
    @IBOutlet weak var classPlaceLabel: UILabel!
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var starOne: UIImageView!
    @IBOutlet var starTwo: UIImageView!
    @IBOutlet var starThree: UIImageView!
    @IBOutlet var starFour:UIImageView!
    @IBOutlet var starFive: UIImageView!
    var cellIndex: IndexPath!
    @IBOutlet var view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.subjectNameLabel.adjustsFontSizeToFitWidth = true
        self.classPlaceLabel.adjustsFontSizeToFitWidth = true
        self.profLabel.adjustsFontSizeToFitWidth = true
        //ChalkboardSE-Regular
        let font = UIFont(name: "ArialRoundedMTBold", size: 17)
        let font1 = UIFont(name: "ArialMT", size: 14)
        // ラベルのフォントを設定する
        subjectNameLabel.font = font
        dayTimeLabel.font = font1
        profLabel.font = font1
        classPlaceLabel.font = font1
        detailButton.layer.cornerRadius = 5
        // 2.影の設定
        // 影の濃さ
        detailButton.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        detailButton.layer.shadowRadius = 3
        // 影の色
        detailButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        detailButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        // add shadow on cell
//        backgroundColor = .clear // very important
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0.23
//        layer.shadowRadius = 5
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 8
        view.clipsToBounds = true

        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
            
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toDetailButton(button: UIButton){
        self.delegate?.didTapDetailButton(button: button, indexPath: cellIndex)
    }
    
}
