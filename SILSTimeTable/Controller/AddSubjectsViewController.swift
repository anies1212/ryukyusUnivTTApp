//
//  AddSubjectsViewController.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/09/23.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import SkyFloatingLabelTextField
import SwiftyPickerPopover
import Lottie

class AddSubjectsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var subjectNameTextField: SkyFloatingLabelTextField!
    @IBOutlet var creditTextField: SkyFloatingLabelTextField!
    @IBOutlet var placeTextField: SkyFloatingLabelTextField!
    @IBOutlet var profTextField: SkyFloatingLabelTextField!
    @IBOutlet var dayShowLabel: UILabel!
    @IBOutlet var dayTimeSelectButton: UIButton!
    @IBOutlet var timeSelectButton: UIButton!
    @IBOutlet var timeShowLabel: UILabel!
    var day: String!
    var time: String!



    override func viewDidLoad() {
        super.viewDidLoad()
        

        showAnimation()
        self.subjectNameTextField.delegate = self
        self.creditTextField.delegate = self
        self.placeTextField.delegate = self
        self.profTextField.delegate = self
        
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        
        // 1.角丸設定
        // UIButtonの変数名.layer.cornerRadius = 角丸の大きさ
        dayTimeSelectButton.layer.cornerRadius = 7
        timeSelectButton.layer.cornerRadius = 7
        // 2.影の設定
        // 影の濃さ
        dayTimeSelectButton.layer.shadowOpacity = 0.2
        timeSelectButton.layer.shadowOpacity = 0.2
        // 影のぼかしの大きさ
        dayTimeSelectButton.layer.shadowRadius = 1
        timeSelectButton.layer.shadowRadius = 1
        // 影の色
        dayTimeSelectButton.layer.shadowColor = UIColor.black.cgColor
        timeSelectButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        dayTimeSelectButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        timeSelectButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // MARK: 保存
    @IBAction func save() {
        if subjectNameTextField.text?.isEmpty == false && creditTextField.text?.isEmpty == false && profTextField.text?.isEmpty == false && placeTextField.text?.isEmpty == false && dayShowLabel.text?.isEmpty == false {
            
            if day == nil{
                day = "月"
            }
            
            if time == nil{
                time = "１"
            }
            
            let dayTime = day + time
            print("dayTime:\(dayTime)")
            
            let object = NCMBObject(className: "subjects")
            object?.setObject(subjectNameTextField.text, forKey: "subjectName")
            object?.setObject(creditTextField.text, forKey: "creditNum")
            object?.setObject(profTextField.text, forKey: "Prof")
            object?.setObject(placeTextField.text, forKey: "classPlace")
            object?.setObject(dayTime, forKey: "dayTime")
            object?.setObject("0", forKey: "star")
            object?.setObject("-", forKey: "scoringMethod")
            object?.setObject("-", forKey: "opinion")
            object?.setObject("-", forKey: "lectureLevel")
            object?.setObject("-", forKey: "examsLevel")
            object?.setObject("-", forKey: "examFrequency")
            object?.setObject("0", forKey: "creditDifficultyStarNum")
            object?.setObject("-", forKey: "attendantsCheckFrequency")
            object?.setObject("-", forKey: "assignmentsLevel")
            object?.setObject("-", forKey: "assignmentsCheckFrequency")
            
            
            //他の保存
            
            object?.saveInBackground({ (error) in
                if error != nil {
                    HUD.show(.error)
                    
                    return
                }
                
                let alertController = UIAlertController(title: "科目選択画面に反映されました", message: "指定した曜日、時限の科目選択画面にて検索ください", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (backAction) in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                
                
            })
        } else {
            let alertController = UIAlertController(title: "全ての授業情報欄を入力してください", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (backAction) in
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
//    var dayList = [
//        "月１","月２","月３","月４","月５","月６",
//        "火１","火２","火３","火４","火５","火６",
//        "水１","水２", "水３","水４","水５","水６",
//        "木１","木２","木３","木４","木５","木６",
//        "金１","金２","金３","金４","金５", "金６",
//    ]
    
    @IBAction func daySelectButtonFunc(){
        let displayStringFor:((String?)->String?)? = { string in
           if let s = string {
              switch(s){
              case "月":
                return "月"
              case "火":
                  return "火"
              case "水":
                  return "水"
              case "木":
                  return "木"
              case "金":
                  return "金"
             
              default:
                 return s
              }
            }
            
          return nil
          }
                
        let p = StringPickerPopover(title: "StringPicker", choices: ["月", "火", "水", "木", "金"])
                    .setDisplayStringFor(displayStringFor)
                    .setDoneButton(action: {
                        popover, selectedRow, selectedString in
                        print("done row \(selectedRow) \(selectedString)")
                        self.dayShowLabel.text = selectedString
                        self.day = selectedString
                    })
                    .setCancelButton(action: { _, _, _ in
                        print("cancel")
                    })
                p.appear(originView: dayTimeSelectButton, baseViewController: self)
//                p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
        
        
    }
    
    @IBAction func timeSelectButtonFunc(){
        let displayStringFor:((String?)->String?)? = { string in
           if let s = string {
              switch(s){
              case "１":
                return "１"
              case "２":
                 return "２"
              case "３":
                 return "３"
              case "４":
                  return "４"
              case "５":
                  return "５"
              case "６":
                  return "６"
             
              default:
                 return s
              }
            }
            
          return nil
          }
                
        let p = StringPickerPopover(title: "StringPicker", choices: ["１","２","３", "４", "５", "６"])
                    .setDisplayStringFor(displayStringFor)
                    .setDoneButton(action: {
                        popover, selectedRow, selectedString in
                        print("done row \(selectedRow) \(selectedString)")
                        self.timeShowLabel.text = selectedString
                        self.time = selectedString
                    })
                    .setCancelButton(action: { _, _, _ in
                        print("cancel")
                    })
                p.appear(originView: dayTimeSelectButton, baseViewController: self)
//                p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )

    }
    
    
    func showAnimation() {
        let animationView = AnimationView(name: "addSubject2")
//        animationView.frame = CGRect(x: 0, y: 490, width: view.bounds.width/1.5, height: view.bounds.height/1.5) view.bounds.height/1.005
        animationView.frame = CGRect(x: 0, y: view.frame.height/1.4, width: view.bounds.width/2, height: view.bounds.height/3.5)
//        animationView.frame = view.bounds
//           animationView.center = self.view.center
           animationView.loopMode = .loop
           animationView.contentMode = .scaleAspectFit
           animationView.animationSpeed = 1

           view.addSubview(animationView)

           animationView.play()
       }
    

    


}
