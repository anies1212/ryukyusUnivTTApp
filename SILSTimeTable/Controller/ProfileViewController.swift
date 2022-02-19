//
//  ProfileViewController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/03.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import Lottie
import SwiftyPickerPopover

class ProfileViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var TermsOfUse: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    //    @IBOutlet weak var menuBarButton: UIButton!
    @IBOutlet var creditTotalNumberLabel: UILabel!
    @IBOutlet var creditCommonNumberLabel: UILabel!
    @IBOutlet var creditExpertNumberLabel: UILabel!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var plus2Button: UIButton!
    @IBOutlet var minus2Button: UIButton!
    @IBOutlet var surveryLink: UITextView!
    @IBOutlet var errorSurveyLink: UITextView!
    var creditTotalNum: Int!
    var creditCommonNumber = 0
    var creditExpertNumber = 0
    var isNewUser = false
    var isNewUser2 = false
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var departmentLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var editGradeButton: UIButton!
    @IBOutlet var editDepartmentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editGradeButton.setTitleColor(UIColor.white, for: .normal)
        editDepartmentButton.setTitleColor(UIColor.white, for: .normal)
        editGradeButton.titleLabel?.font = UIFont(name: "HiraginoSans-W3", size: 8)
        editDepartmentButton.titleLabel?.font = UIFont(name: "HiraginoSans-W3", size: 8)
        editGradeButton.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        editDepartmentButton.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        editGradeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        editDepartmentButton.titleLabel?.adjustsFontSizeToFitWidth = true
        gradeLabel.adjustsFontSizeToFitWidth = true
        departmentLabel.adjustsFontSizeToFitWidth = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // 表示したい画像の名前(拡張子含む)を引数とする。
        self.view.addBackground(name: "christmasBack4.jpg")
        
        navigationController?.navigationBar.enableTransparency()
        UINavigationBar.appearance().barTintColor = UIColor.clear
        let font = UIFont(name: "AppleColorEmoji", size: 14)
        let font2 = UIFont(name: "AppleSDGothicNeo-Bold", size: 32)
        let fontForEnglish = UIFont(name: "AppleSDGothicNeo-Bold", size: 32)
        userDisplayNameLabel.font = fontForEnglish
        UserName.font = font2
        TermsOfUse.font = font
        UserName.adjustsFontSizeToFitWidth = true
        userDisplayNameLabel.adjustsFontSizeToFitWidth = true
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.tintColor = UIColor.black
        //　ナビゲーションバーの背景色
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
        ]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        let baseString = "Youtubeチャンネル"
        let baseString2 = "授業評価アンケート"
        let baseString3 = "こちら"
        
        _ = NSMutableAttributedString(string: baseString)
        let attributedString2 = NSMutableAttributedString(string: baseString2)
        let attributedString3 = NSMutableAttributedString(string: baseString3)
        
        attributedString2.addAttribute(.link,
                                       value: "https://docs.google.com/forms/d/e/1FAIpQLSfgjFTSLR2th-hf4N3e-TjEIqH2fuQLIQNT7On7lELSsbbaQg/formResponse",
                                       range: NSString(string: baseString2).range(of: "授業評価アンケート"))
        attributedString3.addAttribute(.link,
                                       value:"https://docs.google.com/forms/d/e/1FAIpQLSdY3DZYHcskVRg-VikVsZ8fOUL6yJ91xBaKrcVMONp-JJbkAg/viewform",
                                       range: NSString(string: baseString3).range(of: "こちら"))
        
        surveryLink.attributedText = attributedString2
//        let str2 = attributedString2.string
//        surveryLink.text = "こちらの\(str2)へのご協力お願いします。"
        errorSurveyLink.attributedText = attributedString3
        
        // isSelectableをtrue、isEditableをfalseにする必要がある
        // （isSelectableはデフォルトtrueだが説明のため記述）

        surveryLink.isSelectable = true
        surveryLink.isEditable = false
        surveryLink.delegate = self
        surveryLink.font = UIFont.systemFont(ofSize: 9)
        errorSurveyLink.isSelectable = true
        errorSurveyLink.isEditable = false
        errorSurveyLink.delegate = self
        errorSurveyLink.font = UIFont.systemFont(ofSize: 9)
        
        // ボタンのインスタンス生成
        let button = UIButton()
        button.frame = CGRect(x:10, y:0,
                              width:60, height:60)
        button.setTitle("", for:UIControl.State.normal)
        button.setImage(UIImage(named: "iconCancel25")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self,
                         action: #selector(crossButtonFunc),
                         for: .touchUpInside)
        self.view.bringSubviewToFront(button)
        self.view.addSubview(button)
        
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let button2 = UIButton()
        button2.frame = CGRect(x: width - 50, y:20,
                               width:30, height:30)
        button2.setTitle("", for:UIControl.State.normal)
        button2.setImage(UIImage(named: "humbergerMenu")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button2.tintColor = .systemBlue
        button2.addTarget(self,
                          action: #selector(showMenu),
                          for: .touchUpInside)
        self.view.bringSubviewToFront(button2)
        self.view.addSubview(button2)
        
//        showAnimation()
        isNewUserFunc()
        isNewUserFunc2()
        fetchCreditNumber()
        
        
    }
    
    @objc func crossButtonFunc(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func showAnimation() {
        let animationView = AnimationView(name: "school")
        //        animationView.frame = CGRect(x: 0, y: 436, width: 400, height: 400) view.bounds.height/1.005
        animationView.frame = CGRect(x: view.frame.width/500, y: view.frame.height/1.7, width: view.bounds.width/1.005, height: 300)
        //           animationView.center = self.view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        view.addSubview(animationView)
        
        animationView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCreditNumber()
        fetchExpertCreditNumber()
        isNewUserFunc()
        isNewUserFunc2()
        
        if let user = NCMBUser.current(){
            userDisplayNameLabel.text = "\(user.object(forKey: "userName") as! String) さん"
            
            let fetchGradeData = NCMBQuery(className: "Grade")
            fetchGradeData?.includeKey("user")
            fetchGradeData?.whereKey("user", equalTo: NCMBUser.current())
            fetchGradeData?.findObjectsInBackground({ result, error in
                if error != nil{
                    print("nil")
                    self.gradeLabel.text = "学年の情報を入力してください"
                } else {
                    if result?.isEmpty == true{
                        self.gradeLabel.text = "学年の情報を入力してください"
                        return
                    }
                    let grades = result as? [NCMBObject]
                    let grade = grades?.first?.object(forKey: "grade") as! String
                    self.gradeLabel.text = "学年:\(grade)"
                }
            })
            
            let fetchDepExpData = NCMBQuery(className: "DepartmentExpert")
            fetchDepExpData?.includeKey("user")
            fetchDepExpData?.whereKey("user", equalTo: NCMBUser.current())
            fetchDepExpData?.findObjectsInBackground({ result, error in
                if error != nil{
                    print("nil")
                } else {
                    if result?.isEmpty == true{
                        self.departmentLabel.text = "学部学科の情報を入力してください"
                        return
                    }
                    
                    let depExps = result as? [NCMBObject]
                    let depExp = depExps?.first?.object(forKey: "departmentExpert") as! String
                    self.departmentLabel.text = "学部学科: \(depExp)"
                }
            })
            
        } else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(identifier: "SignInVC")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
        
        
        
        
        //細かな時間の取得
        
        let now = NSDate()
        let date = DateFormatter()
        date.dateFormat = "HH:mm:ss"
        let string = date.string(from: now as Date)
        
        if "08:30:01" <= string && string <= "12:00:00" {
            
            UserName.text = "今日も1日頑張りましょう！"
            
        } else if "12:00:01" <= string && string <= "18:00:00"{
            
            UserName.text = "今日もあと一踏ん張りです！"
            
        } else if "18:00:01" <= string && string <= "22:00:00"{
            
            UserName.text = "今日も1日おつかれさまでした！"
            
        } else if "22:00:01" <= string && string <= "05:00:00"{
            
            UserName.text = "おやすみなさい"
            
        } else if "05:00:01" <= string && string <= "08:30:00"{
            
            UserName.text = "おはようございます！"
            
        } else {
            print("授業はないよ")
        }
    }
    
    
    @objc func showMenu(){
        let alertController = UIAlertController(title: "Menu", message: "Select Menu", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground { (error) in
                if error != nil {
                    print(error)
                    HUD.show(.error)
                    
                } else {
                    HUD.show(.progress)
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "SignInVC")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    HUD.flash(.success)
                    
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            }
            
        }
        let deleteAction = UIAlertAction(title: "退会する", style: .default) { (action) in
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil{
                    print("error")
                    HUD.show(.error)
                } else {
                    HUD.show(.progress)
                    
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "SignInVC")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    HUD.flash(.success)
                    
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
                
            })
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func plusAction(){
        creditCommonNumber = creditCommonNumber + 1
        creditCommonNumberLabel.text = String(creditCommonNumber)
        print("isNewUserはどうなっている？:\(isNewUser)")
        
        if isNewUser == false{
            // 二回目以降
            let query = NCMBQuery(className: "CreditData")
            query?.includeKey("user")
            query?.whereKey("user", equalTo: NCMBUser.current())
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print (error)
                    HUD.show(.error)
                } else {
                    let credits = result as! [NCMBObject]
                    let credit = credits.first
                    credit?.setObject(self.creditCommonNumber, forKey: "creditNum")
                    credit?.saveInBackground({ (error) in
                        if error != nil {
                            HUD.show(.error)
                        } else {
                            print ("updateSucceed")
                            self.creditTotalNumFunc()
                        }
                    })
                }
            })
            // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
        } else if isNewUser == true {
            //            NCMB上に保存
            let object = NCMBObject(className: "CreditData")
            object?.setObject(self.creditCommonNumber, forKey: "creditNum")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil{
                    HUD.show(.error)
                } else {
                    print("save succeeded")
                    self.creditTotalNumFunc()
                }
            })
        }
    }
    
    @IBAction func plusAction2(){
        creditExpertNumber = creditExpertNumber + 1
        creditExpertNumberLabel.text = String(creditExpertNumber)
        print("isNewUserはどうなっている？:\(isNewUser)")
        
        if isNewUser2 == false{
            // 二回目以降
            let query = NCMBQuery(className: "CreditExpertData")
            query?.includeKey("user")
            query?.whereKey("user", equalTo: NCMBUser.current())
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print (error)
                    HUD.show(.error)
                } else {
                    let credits = result as! [NCMBObject]
                    let credit = credits.first
                    credit?.setObject(self.creditExpertNumber, forKey: "creditExpertNum")
                    credit?.saveInBackground({ (error) in
                        if error != nil {
                            HUD.show(.error)
                        } else {
                            print ("updateSucceed")
                            self.creditTotalNumFunc()
                        }
                    })
                }
            })
            // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
        } else if isNewUser2 == true {
            //            NCMB上に保存
            let object = NCMBObject(className: "CreditExpertData")
            object?.setObject(self.creditExpertNumber, forKey: "creditExpertNum")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil{
                    HUD.show(.error)
                } else {
                    print("save succeeded")
                    self.creditTotalNumFunc()
                }
            })
        }
    }
    
    @IBAction func minusAction(){
        if creditCommonNumber == 0 {
            creditCommonNumber = 0
        } else {
            creditCommonNumber = creditCommonNumber - 1
            creditCommonNumberLabel.text = String(creditCommonNumber)
        }
        
        let query = NCMBQuery(className: "CreditData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print (error)
                HUD.show(.error)
            } else {
                let credits = result as! [NCMBObject]
                let credit = credits.first
                credit?.setObject(self.creditCommonNumber, forKey: "creditNum")
                credit?.saveInBackground({ (error) in
                    if error != nil {
                        print (error)
                        HUD.show(.error)
                    } else {
                        print ("updateSucceed")
                        self.creditTotalNumFunc()
                    }
                })
            }
        })
    }
    
    @IBAction func minusAction2(){
        if creditExpertNumber == 0 {
            creditExpertNumber = 0
        } else {
            creditExpertNumber = creditExpertNumber - 1
            creditExpertNumberLabel.text = String(creditExpertNumber)
        }
        
        let query = NCMBQuery(className: "CreditExpertData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print (error)
                HUD.show(.error)
            } else {
                let credits = result as! [NCMBObject]
                let credit = credits.first
                credit?.setObject(self.creditExpertNumber, forKey: "creditExpertNum")
                credit?.saveInBackground({ (error) in
                    if error != nil {
                        print (error)
                        HUD.show(.error)
                    } else {
                        print ("updateSucceed")
                        self.creditTotalNumFunc()
                    }
                })
            }
        })
    }
    
    func creditTotalNumFunc(){
        creditTotalNum = self.creditExpertNumber + self.creditCommonNumber
        creditTotalNumberLabel.text = String(creditTotalNum)
    }
    
    func fetchCreditNumber(){
        
        let query = NCMBQuery(className: "CreditData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ result, error in
            if error != nil{
                print("error")
                HUD.show(.error)
            } else {
                
                let credits = result as! [NCMBObject]
                
                if credits.isEmpty == true{
                    //                self.isNewUser = true
                    print("no credits")
                } else {
                    //resultでは["1","0","0","0"....]という感じでとってこれている。
                    let credit = credits.first?.object(forKey: "creditNum") as! Int
                    self.creditCommonNumber = credit
                    print("self.receiveAbsentData:\(self.creditCommonNumber)")
                    self.creditCommonNumberLabel.text = String(self.creditCommonNumber)
                    self.isNewUser = false
                    self.creditTotalNumFunc()
                    
                }
            }
        })
    }
    
    func fetchExpertCreditNumber(){
        
        let query = NCMBQuery(className: "CreditExpertData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ result, error in
            if error != nil{
                print("error")
                HUD.show(.error)
            } else {
                
                let credits = result as! [NCMBObject]
                
                if credits.isEmpty == true{
                    //                self.isNewUser = true
                    print("no credits")
                } else {
                    //resultでは["1","0","0","0"....]という感じでとってこれている。
                    let credit = credits.first?.object(forKey: "creditExpertNum") as! Int
                    self.creditExpertNumber = credit
                    print("self.receiveAbsentData:\(self.creditExpertNumber)")
                    self.creditExpertNumberLabel.text = String(self.creditExpertNumber)
                    self.isNewUser2 = false
                    self.creditTotalNumFunc()
                    
                }
            }
        })
    }
    
    
    
    
    //新規ユーザーか否かの判別
    func isNewUserFunc(){
        //colorArrayがすでにある場合、データを取得し、rereceiveに反映させる
        let query = NCMBQuery(className: "CreditData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ result, error in
            if error != nil{
                print("error")
                HUD.show(.error)
            } else {
                
                let credits = result as! [NCMBObject]
                if credits.isEmpty == true{
                    self.isNewUser = true
                } else {
                    self.isNewUser = false
                }
            }
            
        })
        
    }
    
    //新規ユーザーか否かの判別
    func isNewUserFunc2(){
        //colorArrayがすでにある場合、データを取得し、rereceiveに反映させる
        let query = NCMBQuery(className: "CreditExpertData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ result, error in
            if error != nil{
                print("error")
                HUD.show(.error)
            } else {
                
                let credits = result as! [NCMBObject]
                if credits.isEmpty == true{
                    self.isNewUser2 = true
                } else {
                    self.isNewUser2 = false
                }
            }
            
        })
        
    }
    
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        UIApplication.shared.open(URL)
        
        return false
    }
    
    
}
extension ProfileViewController {
    
    
    @IBAction func departmentSelectButtonFunc(){
        let displayStringFor:((String?)->String?)? = { string in
            if let s = string {
                switch(s){
                case "国際地域創造学部 - 専攻プログラムなし":
                    return "国際地域創造学部 - 専攻プログラムなし"
                case "国際地域創造学部 - 地域文化プログラム":
                    return "国際地域創造学部 - 地域文化プログラム"
                case "国際地域創造学部 - 観光地域デザインプログラム":
                    return "国際地域創造学部 - 観光地域デザインプログラム"
                case "国際地域創造学部 - 経営プログラム":
                    return "国際地域創造学部 - 経営プログラム"
                case "国際地域創造学部 - 経済学プログラム":
                    return "国際地域創造学部 - 経済学プログラム"
                case "国際地域創造学部 - 国際言語文化プログラム":
                    return "国際地域創造学部 - 国際言語文化プログラム"
                case "人文社会学部 - 専攻プログラムなし":
                    return "人文社会学部 - 専攻プログラムなし"
                case "人文社会学部 - 国際法政学科":
                    return "人文社会学部 - 国際法政学科"
                case "人文社会学部 - 人間社会学科":
                    return "人文社会学部 - 人間社会学科"
                case "人文社会学部 - 国琉球アジア文化学科":
                    return "人文社会学部 - 国琉球アジア文化学科"
                case "教育学部 - 小学校教育コース":
                    return "教育学部 - 小学校教育コース"
                case "教育学部 - 中学校教育コース":
                    return "教育学部 - 中学校教育コース"
                case "教育学部 - 特別支援教育コース":
                    return "教育学部 - 特別支援教育コース"
                case "理学部 - 数理科学科":
                    return "理学部 - 数理科学科"
                case "理学部 - 物質地球科学科 - 物理系":
                    return "理学部 - 物質地球科学科 - 物理系"
                case "理学部 - 物質地球科学科 - 地学系":
                    return "理学部 - 物質地球科学科 - 地学系"
                case "理学部 - 海洋自然科学科 - 化学系":
                    return "理学部 - 海洋自然科学科 - 化学系"
                case "理学部 - 海洋自然科学科 - 生物系":
                    return "理学部 - 海洋自然科学科 - 生物系"
                case "医学部 - 医学科":
                    return "医学部 - 医学科"
                case "医学部 - 保健学科":
                    return "医学部 - 保健学科"
                case "工学部 - 機械工学コース":
                    return "工学部 - 機械工学コース"
                case "工学部 - エネルギー環境工学コース":
                    return "工学部 - エネルギー環境工学コース"
                case "工学部 - 電気システム工学コース":
                    return "工学部 - 電気システム工学コース"
                case "工学部 - 電子情報通信コース":
                    return "工学部 - 電子情報通信コース"
                case "工学部 - 社会基盤デザインコース":
                    return "工学部 - 社会基盤デザインコース"
                case "工学部 - 建築学コース":
                    return "工学部 - 建築学コース"
                case "工学部 - 知能情報コース":
                    return "工学部 - 知能情報コース"
                case "農学部 - 亜熱帯地域農学科":
                    return "農学部 - 亜熱帯地域農学科"
                case "農学部 - 亜熱帯農林環境科学科":
                    return "農学部 - 亜熱帯農林環境科学科"
                case "農学部 - 地域農業工学科":
                    return "農学部 - 地域農業工学科"
                case "農学部 - 亜熱帯生物資源科学科":
                    return "農学部 - 亜熱帯生物資源科学科"
                    
                default:
                    return s
                }
            }
            
            return nil
        }
        
        let p = StringPickerPopover(title: "StringPicker", choices: ["国際地域創造学部 - 専攻プログラムなし","国際地域創造学部 - 地域文化プログラム", "国際地域創造学部 - 観光地域デザインプログラム","国際地域創造学部 - 経営プログラム","国際地域創造学部 - 経済学プログラム", "国際地域創造学部 - 国際言語文化プログラム", "人文社会学部 - 専攻プログラムなし", "人文社会学部 - 国際法政学科", "人文社会学部 - 人間社会学科", "人文社会学部 - 国琉球アジア文化学科", "教育学部 - 小学校教育コース", "教育学部 - 中学校教育コース", "教育学部 - 特別支援教育コース", "理学部 - 数理科学科", "理学部 - 物質地球科学科 - 物理系", "理学部 - 物質地球科学科 - 地学系", "理学部 - 海洋自然科学科 - 化学系", "理学部 - 海洋自然科学科 - 生物系", "医学部 - 医学科", "医学部 - 保健学科", "工学部 - 機械工学コース", "工学部 - エネルギー環境工学コース", "工学部 - 電気システム工学コース", "工学部 - 電子情報通信コース", "工学部 - 社会基盤デザインコース", "工学部 - 建築学コース", "工学部 - 知能情報コース", "農学部 - 亜熱帯地域農学科", "農学部 - 亜熱帯農林環境科学科", "農学部 - 地域農業工学科", "農学部 - 亜熱帯生物資源科学科"])
            .setDisplayStringFor(displayStringFor)
            .setDoneButton(action: {
                popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
                self.departmentLabel.text = "学部学科:\(selectedString)"
                
                let query = NCMBQuery(className: "DepartmentExpert")
                query?.includeKey("user")
                query?.whereKey("user", equalTo: NCMBUser.current())
                query?.findObjectsInBackground({ (result, error) in
                    if error != nil {
                        print (error)
                    } else {
                        
                        if result?.isEmpty == true{
                            let object = NCMBObject(className: "DepartmentExpert")
                            object?.setObject(selectedString, forKey: "departmentExpert")
                            object?.setObject(NCMBUser.current(), forKey: "user")
                            object?.saveInBackground({ (error) in
                                if error != nil{
                                    HUD.show(.error)
                                } else {
                                    print("success")
                                }
                            })
                            return
                        }
                        
                        let depExps = result as! [NCMBObject]
                        let depExp = depExps.first
                        depExp?.setObject(selectedString, forKey: "departmentExpert")
                        depExp?.saveInBackground({ (error) in
                            if error != nil {
                                print (error)
                            } else {
                                print ("updateSucceed")
                            }
                        })
                    }
                })
            })
            .setCancelButton(action: { _, _, _ in
                print("cancel")
            })
        p.appear(originView: editDepartmentButton, baseViewController: self)
    }
    
    @IBAction func gradeSelectButtonFunc(){
        let displayStringFor:((String?)->String?)? = { string in
            if let s = string {
                switch(s){
                case "1年生":
                    return "1年生"
                case "2年生":
                    return "2年生"
                case "3年生":
                    return "3年生"
                case "4年生":
                    return "4年生"
                case "5年生":
                    return "5年生"
                case "その他":
                    return "その他"
                    
                default:
                    return s
                }
            }
            
            return nil
        }
        
        let p = StringPickerPopover(title: "StringPicker", choices: ["1年生","2年生", "3年生","4年生","5年生", "その他"])
            .setDisplayStringFor(displayStringFor)
            .setDoneButton(action: {
                popover, selectedRow, selectedString in
                //                        print("done row \(selectedRow) \(selectedString)")
                
                self.gradeLabel.text = "学年:\(selectedString)"
                let query = NCMBQuery(className: "Grade")
                query?.includeKey("user")
                query?.whereKey("user", equalTo: NCMBUser.current())
                query?.findObjectsInBackground({ (result, error) in
                    if error != nil {
                        print (error)
                    } else {
                        print("what is in result here?:\(result)")
                        
                        if result?.isEmpty == true{
                            let object = NCMBObject(className: "Grade")
                            object?.setObject(selectedString, forKey: "grade")
                            object?.setObject(NCMBUser.current(), forKey: "user")
                            object?.saveInBackground({ (error) in
                                if error != nil{
                                    HUD.show(.error)
                                } else {
                                    print("success")
                                }
                            })
                            return
                        }
                        
                        let grades = result as! [NCMBObject]
                        let grade = grades.first
                        grade?.setObject(selectedString, forKey: "grade")
                        grade?.saveInBackground({ (error) in
                            if error != nil {
                                print (error)
                            } else {
                                print ("updateSucceed")
                            }
                        })
                    }
                })
            })
            .setCancelButton(action: { _, _, _ in
                print("cancel")
            })
        p.appear(originView: editGradeButton, baseViewController: self)
    }
}

extension UIView {
    func addBackground(name: String) {
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        // スクリーンサイズにあわせてimageViewの配置
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        //imageViewに背景画像を表示
        imageViewBackground.image = UIImage(named: name)
        imageViewBackground.alpha = 0.5

        // 画像の表示モードを変更。
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

        // subviewをメインビューに追加
        self.addSubview(imageViewBackground)
        // 加えたsubviewを、最背面に設置する
        self.sendSubviewToBack(imageViewBackground)
    }
}
