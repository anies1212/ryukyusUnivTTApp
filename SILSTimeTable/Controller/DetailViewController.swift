//
//  DetailViewController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/22.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import Lottie

class DetailViewController: UIViewController {
    lazy var loadingView: AnimationView = {
        let animationView = AnimationView(name: "loadAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1

        return animationView
    }()
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var ClassroomLabel: UILabel!
    @IBOutlet weak var ProfNameLabel: UILabel!
    @IBOutlet weak var DayDateLabel: UILabel!
    @IBOutlet var DetailLabel:UILabel!
    @IBOutlet weak var Classroom: UILabel!
    @IBOutlet weak var DayDate: UILabel!
    @IBOutlet weak var Prof: UILabel!
    @IBOutlet weak var creditNumLabel: UILabel!
    @IBOutlet weak var CreditNum: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var attendantLabel: UILabel!
    @IBOutlet weak var absentLabel: UILabel!
    @IBOutlet weak var lateLabel: UILabel!
    @IBOutlet weak var attendantNumLabel: UILabel!
    @IBOutlet weak var absentNumLabel: UILabel!
    @IBOutlet weak var lateNumLabel: UILabel!
    @IBOutlet var greenColorChangeButton: UIButton!
    @IBOutlet var blueColorChangeButton: UIButton!
    @IBOutlet var orangeColorChangeButton: UIButton!
    @IBOutlet var pinkColorChangeButton: UIButton!
    
    var sendSubjectName: String!
    var isNewUser = false
    var attendantNum: Int! = 0
    var absentNum: Int! = 0
    var lateNum: Int! = 0
    var attendantNumString: String!
    var receiveSubjectName: String!
    var receiveSelectedCollectionViewCell: Int!
    var recieveJoinedIndexPath: String?
    var detail = [Class]()
    var q =  ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    var receiveForColor = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    var receiveAttendanceData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var receiveAbsentData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var receiveLateData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont(name: "Arial-BoldMT", size: 20)
        let font1 = UIFont(name: "ArialMT", size: 13)
        let font2 = UIFont(name: "AvenirNext-Medium", size: 18)
        let font3 = UIFont(name: "ArialMT", size: 17)
        
        
        subjectNameLabel.font = font
        ClassroomLabel.font = font1
        ProfNameLabel.font = font1
        DayDateLabel.font = font1
        DetailLabel.font = font
        Classroom.font = font1
        DayDate.font = font1
        Prof.font = font1
        creditNumLabel.font = font1
        CreditNum.font = font1
        attendanceLabel.font = font2
        attendantLabel.font = font3
        attendantNumLabel.font = font3
        absentLabel.font = font3
        absentNumLabel.font = font3
        lateLabel.font = font3
        lateNumLabel.font = font3
        
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
        


        
        //緑ボタン
        //影の設定
        // 影の濃さ
        greenColorChangeButton.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        greenColorChangeButton.layer.shadowRadius = 2
        // 影の色
        greenColorChangeButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        greenColorChangeButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        //外枠の色を指定
        self.greenColorChangeButton.layer.borderColor = #colorLiteral(red: 0.9062405229, green: 0.9008534551, blue: 0.910381496, alpha: 1)
        
        //外枠の太さを指定
        self.greenColorChangeButton.layer.borderWidth = 0.8
        
        //青ボタン
        //影の設定
        // 影の濃さ
        blueColorChangeButton.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        blueColorChangeButton.layer.shadowRadius = 2
        // 影の色
        blueColorChangeButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        blueColorChangeButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        //外枠の色を指定
        self.blueColorChangeButton.layer.borderColor = #colorLiteral(red: 0.9062405229, green: 0.9008534551, blue: 0.910381496, alpha: 1)
        
        //外枠の太さを指定
        self.blueColorChangeButton.layer.borderWidth = 0.8
        
        //オレンジボタン
        //影の設定
        // 影の濃さ
        orangeColorChangeButton.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        orangeColorChangeButton.layer.shadowRadius = 2
        // 影の色
        orangeColorChangeButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        orangeColorChangeButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        //外枠の色を指定
        self.orangeColorChangeButton.layer.borderColor = #colorLiteral(red: 0.9062405229, green: 0.9008534551, blue: 0.910381496, alpha: 1)
        
        //外枠の太さを指定
        self.orangeColorChangeButton.layer.borderWidth = 0.8
        
        //ピンクボタン
        //影の設定
        // 影の濃さ
        pinkColorChangeButton.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        pinkColorChangeButton.layer.shadowRadius = 2
        // 影の色
        pinkColorChangeButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        pinkColorChangeButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        //外枠の色を指定
        self.pinkColorChangeButton.layer.borderColor = #colorLiteral(red: 0.9062405229, green: 0.9008534551, blue: 0.910381496, alpha: 1)
        
        //外枠の太さを指定
        self.pinkColorChangeButton.layer.borderWidth = 0.8
       
        resetNavBarColor()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isNewUserFunc()
        loadData()
        fetchAttendNumber()
        fetchAbsentNumber()
        fetchLateNumber()
        resetNavBarColor()

    }
    

    
    func loadData(){
//        HUD.show(.progress)
        startLoading()
        let query = NCMBQuery(className: "subjects")
        // 選択されたobjectIdと同じ授業を取ってくる
        query?.whereKey("objectId", equalTo: recieveJoinedIndexPath)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                HUD.show(.error)
            } else {
                
                self.detail = [Class]()
                
                for detail in result as! [NCMBObject] {
                    let classModel = Class(objectId: detail.objectId, subjectName: detail.object(forKey: "subjectName") as! String, classPlace: detail.object(forKey: "classPlace") as! String, Prof: detail.object(forKey: "Prof") as! String, dayTime: detail.object(forKey: "dayTime") as! String, creditNum: detail.object(forKey: "creditNum") as! String, star: detail.object(forKey: "star") as! String, assignmentsCheckFrequency: detail.object(forKey: "assignmentsCheckFrequency") as! String, assignmentsLevel: detail.object(forKey: "assignmentsLevel") as! String, attendantsCheckFrequency: detail.object(forKey: "attendantsCheckFrequency") as! String, creditDifficultyStarNum: detail.object(forKey: "creditDifficultyStarNum") as! String, examFrequency: detail.object(forKey: "examFrequency") as! String, examsLevel: detail.object(forKey: "examsLevel") as! String, lectureLevel: detail.object(forKey: "lectureLevel") as! String, scoringMethod: detail.object(forKey: "scoringMethod") as! String, opinion: detail.object(forKey: "opinion") as! String)
                    
                    // 詳細画面で表示されている授業情報を全部持ってきている
                    // 値は1個しか入る可能性がないのでfor文でやる必要はぶっちゃけない
                    
                    self.detail.append(classModel)
                    
                    self.subjectNameLabel.text = self.detail[0].subjectName
                    self.ClassroomLabel.text = self.detail[0].classPlace
                    self.ProfNameLabel.text = self.detail[0].Prof
                    self.DayDateLabel.text = self.detail[0].dayTime
                    self.creditNumLabel.text = self.detail[0].creditNum

                }
            }
        })
//        resetNavBarColor()
        self.stopLoading()
    }
    
    
    @IBAction func delete(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
            
            HUD.flash(.success)
            // 二回目以降
            let query = NCMBQuery(className: "Data")
            query?.includeKey("user")
            query?.whereKey("user", equalTo: NCMBUser.current())
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print (error)
                } else {
                    let schedules = result as! [NCMBObject]
                    let schedule = schedules.first
                    self.q[self.receiveSelectedCollectionViewCell] = ""
                    schedule?.setObject(self.q, forKey: "selectSubject")
                    schedule?.saveInBackground({ (error) in
                        if error != nil {
                            print (error)
                            HUD.show(.error)
                        } else {
                            print ("updateSucceed")
                              
                        }
                        
                        
                    })
                }
            })
            
            let query2 = NCMBQuery(className: "attendantData")
            query2?.includeKey("user")
            query2?.whereKey("user", equalTo: NCMBUser.current())
            query2?.findObjectsInBackground({ result, error in
                if error != nil{
                    print("error")
                } else {
                    let attends = result as! [NCMBObject]
                    let attend = attends.first
                    print("ここは何が呼ばれているのだ？？（出）:\(self.receiveAttendanceData[self.receiveSelectedCollectionViewCell] )")
                    self.receiveAttendanceData[self.receiveSelectedCollectionViewCell] = 0
                    
                    attend?.setObject(self.receiveAttendanceData, forKey: "attendNumArray")
                    attend?.saveInBackground({ error in
                        if error != nil {
                            print ("error")
                        } else {
                            print("successfully deleted")
                        }
                    })
                }
            })
            
            let query3 = NCMBQuery(className: "absentData")
            query3?.includeKey("user")
            query3?.whereKey("user", equalTo: NCMBUser.current())
            query3?.findObjectsInBackground({ result, error in
                if error != nil{
                    print("error")
                } else {
                    let absents = result as! [NCMBObject]
                    let absent = absents.first
                    self.receiveAbsentData[self.receiveSelectedCollectionViewCell] = 0
                    absent?.setObject(self.receiveAbsentData, forKey: "absentNumArray")
                    absent?.saveInBackground({ error in
                        if error != nil {
                            print ("error")
                        } else {
                            print("successfully deleted")
                        }
                    })
                }
            })
            
            let query4 = NCMBQuery(className: "lateData")
            query4?.includeKey("user")
            query4?.whereKey("user", equalTo: NCMBUser.current())
            query4?.findObjectsInBackground({ result, error in
                if error != nil{
                    print("error")
                } else {
                    let lates = result as! [NCMBObject]
                    let late = lates.first
                    self.receiveLateData[self.receiveSelectedCollectionViewCell] = 0
                    late?.setObject(self.receiveLateData, forKey: "lateNumArray")
                    late?.saveInBackground({ error in
                        if error != nil {
                            print ("error")
                        } else {
                            print("successfully deleted")
                        }
                    })
                }
            })
            
            let query5 = NCMBQuery(className: "colorData")
            query5?.includeKey("user")
            query5?.whereKey("user", equalTo: NCMBUser.current())
            query5?.findObjectsInBackground({ result, error in
                if error != nil {
                    print ("error")
                } else {
                    let colors = result as! [NCMBObject]
                    let color = colors.first
                    print("ここは何が呼ばれているのだ（色）？？:\(self.receiveForColor[self.receiveSelectedCollectionViewCell] )")
                    self.receiveForColor[self.receiveSelectedCollectionViewCell] = ""
                    
                    color?.setObject(self.receiveForColor, forKey: "colorArray")
                    color?.saveInBackground({ error in
                        if error != nil{
                            print("error")
                        } else {
                            print("color has deleted")
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            })
            
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func plusAction(){
        attendantNum = attendantNum + 1
        attendantNumLabel.text = String(attendantNum)
        receiveAttendanceData[receiveSelectedCollectionViewCell] = attendantNum
        
        print("receiveAttendanceData[receiveSelectedCollectionViewCell]:\(receiveAttendanceData[receiveSelectedCollectionViewCell])")
        print("receiveAttendanceData:\(receiveAttendanceData)")
        if isNewUser == false{
            // 二回目以降
            let query = NCMBQuery(className: "attendantData")
            query?.includeKey("user")
            query?.whereKey("user", equalTo: NCMBUser.current())
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print (error)
                    HUD.show(.error)
                } else {
                    let attendants = result as! [NCMBObject]
                    let attendant = attendants.first
                    attendant?.setObject(self.receiveAttendanceData, forKey: "attendNumArray")
                    attendant?.saveInBackground({ (error) in
                        if error != nil {
                            HUD.show(.error)
                        } else {
                            print ("updateSucceed")
                        }
                    })
                }
            })
            // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
        } else if isNewUser == true {
            //            NCMB上に保存
            let object = NCMBObject(className: "attendantData")
            object?.setObject(receiveAttendanceData, forKey: "attendNumArray")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil{
                    HUD.show(.error)
                } else {
                    print("save succeeded")
                }
            })
        }
    }
    
    @IBAction func minusAction(){
        if attendantNum == 0 {
            attendantNum = 0
        } else {
            attendantNum = attendantNum - 1
            attendantNumLabel.text = String(attendantNum)
            receiveAttendanceData[receiveSelectedCollectionViewCell] = attendantNum
            

            let query = NCMBQuery(className: "attendantData")
            query?.includeKey("user")
            query?.whereKey("user", equalTo: NCMBUser.current())
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print (error)
                    HUD.show(.error)
                } else {
                    let attendants = result as! [NCMBObject]
                    let attendant = attendants.first
                    attendant?.setObject(self.receiveAttendanceData, forKey: "attendNumArray")
                    attendant?.saveInBackground({ (error) in
                        if error != nil {
                            print (error)
                            HUD.show(.error)
                        } else {
                            print ("updateSucceed")
                        }
                    })
                }
            })
        }
        
    }
    
    
    @IBAction func plusAction2(){
        
        absentNum = absentNum + 1
        absentNumLabel.text = String(absentNum)
        
        receiveAbsentData[receiveSelectedCollectionViewCell] = absentNum
        
        print("receiveAbsentData[receiveSelectedCollectionViewCell]:\(receiveAbsentData[receiveSelectedCollectionViewCell])")
        print("receiveAbsentDataAttendanceData:\(receiveAbsentData)")
        if isNewUser == false{
            // 二回目以降
            let query = NCMBQuery(className: "absentData")
            query?.includeKey("user")
            query?.whereKey("user", equalTo: NCMBUser.current())
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print (error)
                    HUD.show(.error)
                } else {
                    let absents = result as! [NCMBObject]
                    let absent = absents.first
                    absent?.setObject(self.receiveAbsentData, forKey: "absentNumArray")
                    absent?.saveInBackground({ (error) in
                        if error != nil {
                            print (error)
                            HUD.show(.error)
                        } else {
                            print ("updateSucceed")
                        }
                    })
                }
            })
            // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
        } else if isNewUser == true {
            
            //            NCMB上に保存
            let object = NCMBObject(className: "absentData")
            object?.setObject(receiveAbsentData, forKey: "absentNumArray")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil{
                    HUD.show(.error)
                }
            })
        }
    }
        
    
    
    @IBAction func minusAction2(){
        if absentNum == 0 {
            absentNum = 0
        } else {
            absentNum = absentNum - 1
            absentNumLabel.text = String(absentNum)
            receiveAbsentData[receiveSelectedCollectionViewCell] = absentNum
        }
        
        let query = NCMBQuery(className: "absentData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print (error)
                HUD.show(.error)
            } else {
                let absents = result as! [NCMBObject]
                let absent = absents.first
                absent?.setObject(self.receiveAbsentData, forKey: "absentNumArray")
                absent?.saveInBackground({ (error) in
                    if error != nil {
                        print (error)
                        HUD.show(.error)
                    } else {
                        print ("updateSucceed")
                    }
                })
            }
        })
    }
        

        
    
    
    @IBAction func plusAction3(){
        lateNum = lateNum + 1
        lateNumLabel.text = String(lateNum)
        
        receiveLateData[receiveSelectedCollectionViewCell] = lateNum
        
        print("receiveLateData[receiveSelectedCollectionViewCell]:\(receiveLateData[receiveSelectedCollectionViewCell])")
        print("receiveLateDataAttendanceData:\(receiveLateData)")
        if isNewUser == false{
            // 二回目以降
            let query = NCMBQuery(className: "lateData")
            query?.includeKey("user")
            query?.whereKey("user", equalTo: NCMBUser.current())
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print (error)
                    HUD.show(.error)
                } else {
                    let lates = result as! [NCMBObject]
                    let late = lates.first
                    late?.setObject(self.receiveLateData, forKey: "lateNumArray")
                    late?.saveInBackground({ (error) in
                        if error != nil {
                            print (error)
                            HUD.show(.error)
                        } else {
                            print ("updateSucceed")
                        }
                    })
                }
            })
            // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
        } else if isNewUser == true{
            //            NCMB上に保存
            let object = NCMBObject(className: "lateData")
            object?.setObject(receiveLateData, forKey: "lateNumArray")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil{
                    HUD.show(.error)
                }
            })
        }
    }
    
    @IBAction func minusAction3(){
        if lateNum == 0 {
            lateNum = 0
        } else {
            lateNum = lateNum - 1
            lateNumLabel.text = String(lateNum)
            receiveLateData[receiveSelectedCollectionViewCell] = lateNum
        }
        
        let query = NCMBQuery(className: "lateData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print (error)
                HUD.show(.error)
            } else {
                let lates = result as! [NCMBObject]
                let late = lates.first
                late?.setObject(self.receiveLateData, forKey: "lateNumArray")
                late?.saveInBackground({ (error) in
                    if error != nil {
                        print (error)
                        HUD.show(.error)
                    } else {
                        print ("updateSucceed")
                    }
                })
            }
        })
    }
    
    func fetchAttendNumber(){
        
        
        //colorArrayがすでにある場合、データを取得し、rereceiveに反映させる
        let query = NCMBQuery(className: "attendantData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ result, error in
            if error != nil{
                print("error")
                HUD.show(.error)
            } else {
                
                let attendants = result as! [NCMBObject]
                if attendants.isEmpty == true{
//                    self.isNewUser = true
                    print("no attendants")
                } else {
                //resultでは["1","0","0","0"....]という感じでとってこれている。
                let attendant = attendants.first?.object(forKey: "attendNumArray") as! [Int]
                self.receiveAttendanceData = attendant
                print("self.receiveAttendanceData:\(self.receiveAttendanceData)")
                self.attendantNum = self.receiveAttendanceData[self.receiveSelectedCollectionViewCell]
                self.attendantNumLabel.text = String(self.receiveAttendanceData[self.receiveSelectedCollectionViewCell])
                    self.isNewUser = false
                }
            }
        })
        
    }

    
    func fetchAbsentNumber(){

    let query = NCMBQuery(className: "absentData")
    query?.includeKey("user")
    query?.whereKey("user", equalTo: NCMBUser.current())
    
    query?.findObjectsInBackground({ result, error in
        if error != nil{
            print("error")
            HUD.show(.error)
        } else {
            
            let absents = result as! [NCMBObject]
            
            if absents.isEmpty == true{
//                self.isNewUser = true
                print("no absent")
            } else {
            //resultでは["1","0","0","0"....]という感じでとってこれている。
            let absent = absents.first?.object(forKey: "absentNumArray") as! [Int]
            self.receiveAbsentData = absent
            print("self.receiveAbsentData:\(self.receiveAbsentData)")
            self.absentNum = self.receiveAbsentData[self.receiveSelectedCollectionViewCell]
            self.absentNumLabel.text = String(self.receiveAbsentData[self.receiveSelectedCollectionViewCell])
            self.isNewUser = false
            }
        }
    })
    }

    func fetchLateNumber(){
        
        let query = NCMBQuery(className: "lateData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ result, error in
            if error != nil{
                print("error")
                HUD.show(.error)
            } else {
                
                let lates = result as! [NCMBObject]
                if lates.isEmpty == true{
//                    self.isNewUser = true
                    print("no late")
                } else {
                    //resultでは["1","0","0","0"....]という感じでとってこれている。
                    let late = lates.first?.object(forKey: "lateNumArray") as! [Int]
                    self.receiveLateData = late
                    print("self.receiveLateData:\(self.receiveLateData)")
                    self.lateNum = self.receiveLateData[self.receiveSelectedCollectionViewCell]
                    self.lateNumLabel.text = String(self.receiveLateData[self.receiveSelectedCollectionViewCell])
                    self.isNewUser = false
                    
                }
            }
        })
        
    }
    
    
    @IBAction func yourGreenBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = .clear
        if sender.isSelected{
            receiveForColor[receiveSelectedCollectionViewCell] = ""
            
            
            
            subjectNameLabel.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
            //　ナビゲーションバーの背景色
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
            ]

            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
            receiveForColor[receiveSelectedCollectionViewCell] = "green"
            
            
            // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
            if receiveForColor[receiveSelectedCollectionViewCell] == "" {
                //NCMB上に保存
                let object = NCMBObject(className: "colorData")
                object?.setObject(receiveForColor, forKey: "colorArray")
                object?.setObject(NCMBUser.current(), forKey: "user")
                object?.saveInBackground({ (error) in
                    if error != nil{
                        HUD.show(.error)
                    } else {
                        print("success")
                    }
                })
            } else {
                // 二回目以降
                let query = NCMBQuery(className: "colorData")
                query?.includeKey("user")
                query?.whereKey("user", equalTo: NCMBUser.current())
                query?.findObjectsInBackground({ (result, error) in
                    if error != nil {
                        print (error)
                        HUD.show(.error)
                    } else {
                        let colors = result as! [NCMBObject]
                        let color = colors.first
                        color?.setObject(self.receiveForColor, forKey: "colorArray")
                        color?.saveInBackground({ (error) in
                            if error != nil {
                                print (error)
                                HUD.show(.error)
                            } else {
                                print ("updateSucceed")
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func yourBlueBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = .clear
        if sender.isSelected{
            receiveForColor[receiveSelectedCollectionViewCell] = ""
            
            subjectNameLabel.backgroundColor = #colorLiteral(red: 0.7269489169, green: 0.9554366469, blue: 0.9881481528, alpha: 1)
            //　ナビゲーションバーの背景色
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 0.7269489169, green: 0.9554366469, blue: 0.9881481528, alpha: 1)
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
            ]

            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
            receiveForColor[receiveSelectedCollectionViewCell] = "blue"
            
            // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
            if receiveForColor[receiveSelectedCollectionViewCell] == "" {
                //NCMB上に保存
                let object = NCMBObject(className: "colorData")
                object?.setObject(receiveForColor, forKey: "colorArray")
                object?.setObject(NCMBUser.current(), forKey: "user")
                object?.saveInBackground({ (error) in
                    if error != nil{
                        HUD.show(.error)
                    } else {
                        print("success")
                    }
                })
            } else {
                // 二回目以降
                let query = NCMBQuery(className: "colorData")
                query?.includeKey("user")
                query?.whereKey("user", equalTo: NCMBUser.current())
                query?.findObjectsInBackground({ (result, error) in
                    if error != nil {
                        print (error)
                        HUD.show(.error)
                    } else {
                        let colors = result as! [NCMBObject]
                        let color = colors.first
                        color?.setObject(self.receiveForColor, forKey: "colorArray")
                        color?.saveInBackground({ (error) in
                            if error != nil {
                                print (error)
                                HUD.show(.error)
                            } else {
                                print ("updateSucceed")
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func yourOrangeBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = .clear
        if sender.isSelected{
            receiveForColor[receiveSelectedCollectionViewCell] = ""
            
            subjectNameLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
            //　ナビゲーションバーの背景色
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
            ]

            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
            receiveForColor[receiveSelectedCollectionViewCell] = "orange"
            
            // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
            if receiveForColor[receiveSelectedCollectionViewCell] == "" {
                //NCMB上に保存
                let object = NCMBObject(className: "colorData")
                object?.setObject(receiveForColor, forKey: "colorArray")
                object?.setObject(NCMBUser.current(), forKey: "user")
                object?.saveInBackground({ (error) in
                    if error != nil{
                        HUD.show(.error)
                    } else {
                        print("success")
                    }
                })
            } else {
                // 二回目以降
                let query = NCMBQuery(className: "colorData")
                query?.includeKey("user")
                query?.whereKey("user", equalTo: NCMBUser.current())
                query?.findObjectsInBackground({ (result, error) in
                    if error != nil {
                        print (error)
                        HUD.show(.error)
                    } else {
                        let colors = result as! [NCMBObject]
                        let color = colors.first
                        color?.setObject(self.receiveForColor, forKey: "colorArray")
                        color?.saveInBackground({ (error) in
                            if error != nil {
                                print (error)
                                HUD.show(.error)
                            } else {
                                print ("updateSucceed")
                            }
                        })
                    }
                })
            }
            
        }
    }
    
    @IBAction func yourPinkBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = .clear
        if sender.isSelected{
            receiveForColor[receiveSelectedCollectionViewCell] = ""
            
            subjectNameLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9329919219, blue: 1, alpha: 1)
            //　ナビゲーションバーの背景色
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 1, green: 0.9329919219, blue: 1, alpha: 1)
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
            ]

            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
            receiveForColor[receiveSelectedCollectionViewCell] = "pink"
            
            
//
            // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
            if receiveForColor[receiveSelectedCollectionViewCell] == "" {
                //NCMB上に保存
                let object = NCMBObject(className: "colorData")
                object?.setObject(receiveForColor, forKey: "colorArray")
                object?.setObject(NCMBUser.current(), forKey: "user")
                object?.saveInBackground({ (error) in
                    if error != nil{
                        HUD.show(.error)
                    } else {
                        print("success")
                    }
                })
            } else {
                // 二回目以降
                let query = NCMBQuery(className: "colorData")
                query?.includeKey("user")
                query?.whereKey("user", equalTo: NCMBUser.current())
                query?.findObjectsInBackground({ (result, error) in
                    if error != nil {
                        print (error)
                        HUD.show(.error)
                    } else {
                        let colors = result as! [NCMBObject]
                        let color = colors.first
                        color?.setObject(self.receiveForColor, forKey: "colorArray")
                        color?.saveInBackground({ (error) in
                            if error != nil {
                                print (error)
                                HUD.show(.error)
                            } else {
                                print ("updateSucceed")
                            }
                        })
                    }
                })
            }
            
        }
        
    }
    
    
    //新規ユーザーか否かの判別
    func isNewUserFunc(){
        //colorArrayがすでにある場合、データを取得し、rereceiveに反映させる
        let query = NCMBQuery(className: "attendantData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())

        query?.findObjectsInBackground({ result, error in
            if error != nil{
                print("error")
                HUD.show(.error)
            } else {

                let attendants = result as! [NCMBObject]
                if attendants.isEmpty == true{
                    self.isNewUser = true
                } else {
                    self.isNewUser = false
                }
            }

        })

    }
    
    @IBAction func toReview(){
        performSegue(withIdentifier: "toReview", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReview"{
            let reviewViewController = segue.destination as! ReviewViewController
           
                print("receiveFromDetail:\(self.detail[0].objectId)")
                reviewViewController.receiveSubjectFromDetail = self.detail[0]
            } else {
                print("error")
            }
        }
    
    // 好きなタイミングでこれを呼ぶとアニメーションが始まる.
    func startLoading() {
        view.addSubview(loadingView)
        loadingView.play()
    }

    // 好きなタイミングでこれを呼ぶとアニメーションのViewが消える.
    func stopLoading() {
        loadingView.removeFromSuperview()
    }
    
    func resetNavBarColor(){
        
        transitionCoordinator?.animate(alongsideTransition: { [self] _ in
            if self.receiveForColor[self.receiveSelectedCollectionViewCell] == "blue" {
                self.subjectNameLabel.backgroundColor = #colorLiteral(red: 0.7269489169, green: 0.9554366469, blue: 0.9881481528, alpha: 1)
                //　ナビゲーションバーの背景色
                //            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7269489169, green: 0.9554366469, blue: 0.9881481528, alpha: 1)
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 0.7269489169, green: 0.9554366469, blue: 0.9881481528, alpha: 1)
                
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
            } else {
                print("It was not blue")
            }
            
            if receiveForColor[receiveSelectedCollectionViewCell] == "pink" {
                subjectNameLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9329919219, blue: 1, alpha: 1)
                //　ナビゲーションバーの背景色
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 1, green: 0.9329919219, blue: 1, alpha: 1)
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
            } else {
                print("It was not pink")
            }
            
            if receiveForColor[receiveSelectedCollectionViewCell] == "orange" {
                subjectNameLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
                //　ナビゲーションバーの背景色
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
            } else {
                print("It was not orange")
            }
            
            if receiveForColor[receiveSelectedCollectionViewCell] == "green" {
                subjectNameLabel.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
                //　ナビゲーションバーの背景色
                //　ナビゲーションバーの背景色
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
                
            } else {
                print("It was not green")
            }
            
            if receiveForColor[receiveSelectedCollectionViewCell] == "" {
                subjectNameLabel.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
                //　ナビゲーションバーの背景色
                //　ナビゲーションバーの背景色
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
                
            } else {
                print("It was not green")
            }
            
        }, completion: { [self]  _ in
            if self.receiveForColor[receiveSelectedCollectionViewCell] == "blue" {
                self.subjectNameLabel.backgroundColor = #colorLiteral(red: 0.7269489169, green: 0.9554366469, blue: 0.9881481528, alpha: 1)
                //　ナビゲーションバーの背景色
                //            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7269489169, green: 0.9554366469, blue: 0.9881481528, alpha: 1)
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 0.7269489169, green: 0.9554366469, blue: 0.9881481528, alpha: 1)
                
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
            } else {
                print("It was not blue")
            }
            
            if receiveForColor[receiveSelectedCollectionViewCell] == "pink" {
                subjectNameLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9329919219, blue: 1, alpha: 1)
                //　ナビゲーションバーの背景色
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 1, green: 0.9329919219, blue: 1, alpha: 1)
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
            } else {
                print("It was not pink")
            }
            
            if receiveForColor[receiveSelectedCollectionViewCell] == "orange" {
                subjectNameLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
                //　ナビゲーションバーの背景色
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
            } else {
                print("It was not orange")
            }
            
            if receiveForColor[receiveSelectedCollectionViewCell] == "green" {
                subjectNameLabel.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
                //　ナビゲーションバーの背景色
                //　ナビゲーションバーの背景色
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
                
            } else {
                print("It was not green")
            }
            
            if receiveForColor[receiveSelectedCollectionViewCell] == "" {
                subjectNameLabel.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
                //　ナビゲーションバーの背景色
                //　ナビゲーションバーの背景色
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = #colorLiteral(red: 0.826010406, green: 1, blue: 0.8468800187, alpha: 1)
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
                
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                navigationController?.navigationBar.standardAppearance = appearance
                
                
            } else {
                print("It was not green")
            }
        })
        
    }

}
