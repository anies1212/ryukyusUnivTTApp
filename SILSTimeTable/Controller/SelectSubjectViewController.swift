//
//  SelectSubjectViewController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/05/31.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import Lottie

// 授業を追加するVC
class SelectSubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SelectSubjectTableViewCellDelegate, UIPopoverPresentationControllerDelegate {
    
    lazy var loadingView: AnimationView = {
        let animationView = AnimationView(name: "loadAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1

        return animationView
    }()
    
    func didTapDetailButton(button: UIButton, indexPath: IndexPath){
    performSegue(withIdentifier: "toReview", sender: nil)
            print("ちゃんとおされたよ")
        print("ここのIndexPath次第で眠る:\(indexPath)")
        self.receiveIndexPathNumber = indexPath.row
        print("ここのreceiveIndexPath次第で眠る:\(String(describing: self.receiveIndexPathNumber))")
        
        
        
    }


    var setNowDataString = [""]
//    var sendSubject: String!
    var receiveIndexPathNumber: Int!
    var cellIndex: IndexPath!
    var receiveSelectedSubject: String = ""
    var receiveRow = Int()
    var selectedSubject: String?
    var giveRow: Int!
    var giveIndexItemNumber = Int()
    var flg = Int()
    var giveRowNumber: Int!
    var giveIndexNumber: Int!
    var subjects = [Class]()
    var subjectsAll = [Class]()
    var receiveJoined = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    var userCheck = 0
    @IBOutlet var addSubjectButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var subjectTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectTableView.delegate = self
        subjectTableView.dataSource = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        subjectTableView.rowHeight = 95
        subjectTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "SelectSubjectTableViewCell", bundle: Bundle.main)
        subjectTableView.register(nib, forCellReuseIdentifier: "subjectCell")
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7311812043, green: 0.4956023693, blue: 0.9030517936, alpha: 1)
        
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        nowData()
        loadData()
        newUserCheck()
    }
    

    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        // if you do not set `shadowPath` you'll notice laggy scrolling
        // add this in `willDisplay` method
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear // 透明にすることでスペースとする
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear // 透明にすることでスペースとする
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        // 授業一覧から選択された授業を取得
        selectedSubject = subjects[indexPath.row].subjectName
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        HUD.show(.progress)
        startLoading()
        
        // 元々の時間割の配列の選択されたセルの値を、追加画面で選択された授業に変更
        receiveJoined[receiveRow] = subjects[indexPath.row].objectId
        
        // 初めてのユーザーだと元の配列がないので条件分岐する必要あり
        if userCheck == 0 {
            // 新規登録
            let object = NCMBObject(className: "Data")
            object?.setObject(receiveJoined, forKey: "selectSubject")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil{
                    print(error?.localizedDescription)
                } else {
                    print("success")
                }
                self.navigationController?.popViewController(animated: true)
            })
        } else {
            // 二回目以降
            let query = NCMBQuery(className: "Data")
            query?.includeKey("user")
            query?.whereKey("user", equalTo: NCMBUser.current())
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    print (error)
                    HUD.show(.error)
                } else {
                    let schedules = result as! [NCMBObject]
                    let schedule = schedules.first
                    schedule?.setObject(self.receiveJoined, forKey: "selectSubject")
                    print("self.receiveJoined:\(self.receiveJoined)")
                    schedule?.saveInBackground({ (error) in
                        if error != nil {
                            print (error)
                            HUD.show(.error)
                        } else {
                            print ("updateSucceed")
//                            HUD.hide(animated: true)
                            self.stopLoading()
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    })
                }
            })
        }
    }
    

    
    // NCMB上のその人の時間割が保存された形跡があるか否かをチェック
    func newUserCheck(){
        
        let queryData = NCMBQuery(className: "Data")
        queryData?.includeKey("user")
        queryData?.whereKey("user", equalTo: NCMBUser.current())
        queryData?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error?.localizedDescription)
                HUD.show(.error)
                return
            }
            
            if result?.count == 0 {
                // 新規登録者
                self.userCheck = 0
            } else {
                // 登録済みユーザー
                self.userCheck = 1
            }
            
        })
        
    }
    
    
    // 授業データを一覧表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = subjectTableView.dequeueReusableCell(withIdentifier: "subjectCell") as! SelectSubjectTableViewCell
        cell.subjectNameLabel.adjustsFontSizeToFitWidth = true
        cell.subjectNameLabel?.text = subjects[indexPath.row].subjectName
        cell.dayTimeLabel.text = subjects[indexPath.row].dayTime
        cell.classPlaceLabel.text = subjects[indexPath.row].classPlace
        cell.profLabel.text = subjects[indexPath.row].Prof
        cell.cellIndex = indexPath
        cell.delegate = self
        
        let query = NCMBQuery(className: "subjects")
        query?.whereKey("objectId", equalTo: subjects[indexPath.row].objectId)
        query?.findObjectsInBackground({ (result, error) in
          if error != nil{
            print ("fetched star error")
          } else {
            let stars = result as! [NCMBObject]
            let star = stars.first?.object(forKey: "star") as! String
              print("how many star do you have?\(star)")
              if star == "1"{
                  cell.starOne.image = UIImage(named: "icons8-star-48.png")
              } else if star == "2"{
                  cell.starOne.image = UIImage(named: "icons8-star-48.png")
                  cell.starTwo.image = UIImage(named: "icons8-star-48.png")
              } else if star == "3"{
                  cell.starOne.image = UIImage(named: "icons8-star-48.png")
                  cell.starTwo.image = UIImage(named: "icons8-star-48.png")
                  cell.starThree.image = UIImage(named: "icons8-star-48.png")
              } else if star == "4"{
                  cell.starOne.image = UIImage(named: "icons8-star-48.png")
                  cell.starTwo.image = UIImage(named: "icons8-star-48.png")
                  cell.starThree.image = UIImage(named: "icons8-star-48.png")
                  cell.starFour.image = UIImage(named: "icons8-star-48.png")
              } else if star == "5"{
                  cell.starOne.image = UIImage(named: "icons8-star-48.png")
                  cell.starTwo.image = UIImage(named: "icons8-star-48.png")
                  cell.starThree.image = UIImage(named: "icons8-star-48.png")
                  cell.starFour.image = UIImage(named: "icons8-star-48.png")
                  cell.starFive.image = UIImage(named: "icons8-star-48.png")
              } else if star == "0"{
                  print("no review")
              } else if star == "0.5"{
                  cell.starOne.image = UIImage(named: "starHalf.png")
              } else if star == "1.5"{
                  cell.starOne.image = UIImage(named: "icons8-star-48.png")
                  cell.starTwo.image = UIImage(named: "starHalf.png")
              } else if star == "2.5"{
                  cell.starOne.image = UIImage(named: "icons8-star-48.png")
                  cell.starTwo.image = UIImage(named: "icons8-star-48.png")
                  cell.starThree.image = UIImage(named: "starHalf.png")
              } else if star == "3.5" {
                  cell.starOne.image = UIImage(named: "icons8-star-48.png")
                  cell.starTwo.image = UIImage(named: "icons8-star-48.png")
                  cell.starThree.image = UIImage(named: "icons8-star-48.png")
                  cell.starFour.image = UIImage(named: "starHalf.png")
              } else if star == "4.5"{
                  cell.starOne.image = UIImage(named: "icons8-star-48.png")
                  cell.starTwo.image = UIImage(named: "icons8-star-48.png")
                  cell.starThree.image = UIImage(named: "icons8-star-48.png")
                  cell.starFour.image = UIImage(named: "icons8-star-48.png")
                  cell.starFive.image = UIImage(named: "starHalf.png")
              } else {
                  print("fetch star error")
              }
        }
        })
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReview"{
            let reviewController = segue.destination as! ReviewViewController
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                print("self.subjects[self.receiveIndexPathNumber]:\(self.subjects[self.receiveIndexPathNumber])")
                reviewController.receiveSubject = self.subjects[self.receiveIndexPathNumber]
            }
        } else if segue.identifier == "toAddSubject" {
            let addSubjectViewController = segue.destination as! AddSubjectsViewController
            
        } else {
        
        let viewController = segue.destination as! ViewController
        viewController.receivedClass = selectedSubject
        }
        

    }
    
    
    // 検索バー
    // 「ご」で「えいご」も「こくご」も検索できる仕様
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            guard let self = self else { return }
            
            if let keyword = searchBar.text, !keyword.isEmpty {
                self.subjects = [Class]()
                
                for i in self.subjectsAll {
                    let subjectName = i.subjectName!
                    if subjectName.lowercased().contains(keyword.lowercased()) {
                        self.subjects.append(i)
                    }
                }
                self.subjectTableView.reloadData()
                
            } else {
                self.subjects = self.subjectsAll
                self.subjectTableView.reloadData()
            }
        }
        
        return true
    }
    
    // 検索バーのキャンセルボタンが押された時の処理
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        self.subjects = self.subjectsAll
        self.subjectTableView.reloadData()
        self.searchBar.endEditing(true)
        
    }
    

    
    // 授業情報の一覧に必要なデータをNCMBから引っ張ってくる
    func loadData(){
//        HUD.show(.progress)
        startLoading()
        let query = NCMBQuery(className: "subjects")
        query?.whereKey("dayTime", containedIn: setNowDataString)
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error?.localizedDescription)
                HUD.show(.error)
                return
            }
            
            self.subjects = [Class]()
            self.subjectsAll = [Class]()
            
            for subject in result as! [NCMBObject] {
                let classModel = Class(objectId: subject.objectId, subjectName: subject.object(forKey: "subjectName") as! String, classPlace: subject.object(forKey: "classPlace") as! String, Prof: subject.object(forKey: "Prof") as! String, dayTime: subject.object(forKey: "dayTime") as! String, creditNum: subject.object(forKey: "creditNum") as! String, star: subject.object(forKey: "star") as! String, assignmentsCheckFrequency: subject.object(forKey: "assignmentsCheckFrequency") as! String, assignmentsLevel: subject.object(forKey: "assignmentsLevel") as! String, attendantsCheckFrequency: subject.object(forKey: "attendantsCheckFrequency") as! String, creditDifficultyStarNum: subject.object(forKey: "creditDifficultyStarNum") as! String, examFrequency: subject.object(forKey: "examFrequency") as! String, examsLevel: subject.object(forKey: "examsLevel") as! String, lectureLevel: subject.object(forKey: "lectureLevel") as! String, scoringMethod: subject.object(forKey: "scoringMethod") as! String, opinion: subject.object(forKey: "opinion") as! String)
                self.subjects.append(classModel)
                self.subjectsAll.append(classModel)
            }
//            HUD.hide(animated: true)
            self.stopLoading()
            self.subjectTableView.reloadData()
        })
    }
    

    
    func nowData(){
        switch receiveRow {
        case 0:
            setNowDataString = ["月１"]
        case 1:
            setNowDataString = ["火１"]
        case 2:
            setNowDataString = ["水１"]
        case 3:
            setNowDataString = ["木１"]
        case 4:
            setNowDataString = ["金１"]
        case 5:
            setNowDataString = ["月２"]
        case 6:
            setNowDataString = ["火２"]
        case 7:
            setNowDataString = ["水２"]
        case 8:
            setNowDataString = ["木２"]
        case 9:
            setNowDataString = ["金２"]
        case 10:
            setNowDataString = ["月３"]
        case 11:
            setNowDataString = ["火３"]
        case 12:
            setNowDataString = ["水３"]
        case 13:
            setNowDataString = ["木３"]
        case 14:
            setNowDataString = ["金３"]
        case 15:
            setNowDataString = ["月４"]
        case 16:
            setNowDataString = ["火４"]
        case 17:
            setNowDataString = ["水４"]
        case 18:
            setNowDataString = ["木４"]
        case 19:
            setNowDataString = ["金４"]
        case 20:
            setNowDataString = ["月５"]
        case 21:
            setNowDataString = ["火５"]
        case 22:
            setNowDataString = ["水５"]
        case 23:
            setNowDataString = ["木５"]
        case 24:
            setNowDataString = ["金５"]
        case 25:
            setNowDataString = ["月６"]
        case 26:
            setNowDataString = ["火６"]
        case 27:
            setNowDataString = ["水６"]
        case 28:
            setNowDataString = ["木６"]
        case 29:
            setNowDataString = ["金６"]
        default:
            break
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

    
    
}

