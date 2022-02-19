//
//  AddTaskToCalendarViewController.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/09/18.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import SkyFloatingLabelTextField
import Lottie

class AddTaskToCalendarViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var taskTitleTextField: SkyFloatingLabelTextField!
    @IBOutlet var taskDetailTextView: UITextView!
    @IBOutlet var startLineDatePicker: UIDatePicker!
    @IBOutlet var deadLineDatePicker: UIDatePicker!
    @IBOutlet var deadLineSwitch: UISwitch!
    @IBOutlet var subjectInputTextField: SkyFloatingLabelTextField!
    var placeholder = "メモを入力"
    var tableView: UITableView  =   UITableView()
    // 最終的に表示させるときに使う一次元配列
    var joined =  ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    // collectionに表示させるための一次元配列
    var z =  ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    var filteredZ = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.taskTitleTextField.delegate = self
        self.taskDetailTextView.delegate = self
        taskDetailTextView.backgroundColor = .white
        taskDetailTextView.text = placeholder
        taskDetailTextView.textColor = .lightGray
        self.subjectInputTextField.delegate = self
        showAnimation()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        //スクリーンの横幅、縦幅を定義
        let bottom = subjectInputTextField.bottom
        let screenWidth = Int(UIScreen.main.bounds.size.width)
        let screenHeight = Int(UIScreen.main.bounds.size.height)  //screenHeight * 17/100
        tableView.frame = CGRect(x:screenWidth * 0/100 , y: Int(bottom-35), width:screenWidth * 60/100, height:screenHeight * 15/100)
        // sampleTableView の dataSource 問い合わせ先を self に
        tableView.delegate = self
        // sampleTableView の delegate 問い合わせ先を self に
        tableView.dataSource = self
        //cellに名前を付ける
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        //実際にviewにsampleTableViewを表示させる
        self.view.addSubview(tableView)
        //cellの高さを指定
        self.tableView.rowHeight = 30
        //セパレーターの色を指定
        tableView.separatorColor = UIColor.lightGray
        tableView.isHidden = true
        
        loadSchedule()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        UINavigationBar.appearance().barTintColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //セクション数を指定

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredZ.count
    }
    
    //cellのコンテンツ

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        //cellにはsampleArrayが一つずつ入るようにするよ！
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont(name: "Arial", size: 10)
        cell.textLabel?.text = filteredZ[indexPath.row]
        return cell
    }
    
    //cellが選択された時の処理

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番セルが押されたよ！")
        tableView.deselectRow(at: indexPath, animated: true)
        subjectInputTextField.text = filteredZ[indexPath.row]
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.1){
            tableView.isHidden = true
        }
    }

    //表示
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if (self.taskDetailTextView.isFirstResponder) {
            self.taskDetailTextView.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.taskTitleTextField{
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
    }
    
    
    

    

    
    // MARK: 保存
    @IBAction func save() {
        if taskTitleTextField.text?.isEmpty == false{
            let object = NCMBObject(className: "TasksData")
            object?.setObject(taskTitleTextField.text, forKey: "taskTitle")
            if subjectInputTextField.text?.isEmpty == false {
                object?.setObject(subjectInputTextField.text, forKey: "InputtedSubject")
            } else {
                object?.setObject("-", forKey: "InputtedSubject")
            }
            if deadLineSwitch.isOn == false {
                object?.setObject(nil, forKey: "startlineDate")
                object?.setObject(nil, forKey: "startlineDateString")
                object?.setObject(false, forKey: "deadline")
                object?.setObject(nil, forKey: "deadLineDate")
                object?.setObject(nil, forKey: "deadlineDateString")
                object?.setObject(false, forKey: "deadLine2")
            } else {
                object?.setObject(startLineDatePicker.date, forKey: "startlineDate")
                object?.setObject(getDate(startLineDatePicker.date), forKey: "startlineDateString")
                object?.setObject(true, forKey: "deadline")
                object?.setObject(deadLineDatePicker.date, forKey: "deadlineDate")
                object?.setObject(getDate(deadLineDatePicker.date), forKey: "deadlineDateString")
                object?.setObject(true, forKey: "deadLine2")
                print("startLineDatePicker:\(getDate(startLineDatePicker.date))")
                print("deadLineDatePicker:\(getDate(deadLineDatePicker.date))")
            }
            
            object?.setObject(taskDetailTextView.text, forKey: "detail")
            object?.setObject(false, forKey: "state")
            object?.setObject(NCMBUser.current(), forKey: "user")
            
            //他の保存
            object?.saveInBackground({ (error) in
                if error != nil {
                    HUD.show(.error)
                    return
                }

                self.dismiss(animated: true, completion: nil)
                
            })
        } else {
            let alertController = UIAlertController(title: "タイトルを入力してください", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (backAction) in
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 日付String取得
    func getDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "メモを入力"
            textView.textColor = UIColor.lightGray
            placeholder = ""
        } else {
            placeholder = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholder = textView.text
    }
    
    func showAnimation() {
        let animationView = AnimationView(name: "workAtOffice")
//        animationView.frame = CGRect(x: 0, y: 490, width: view.bounds.width/1.5, height: view.bounds.height/1.5) view.bounds.height/1.005
        animationView.frame = CGRect(x: view.frame.width/5.35, y: view.frame.height/1.7, width: view.bounds.width/1.75, height: 300)
//        animationView.frame = view.bounds
//           animationView.center = self.view.center
           animationView.loopMode = .loop
           animationView.contentMode = .scaleAspectFit
           animationView.animationSpeed = 1

           view.addSubview(animationView)

           animationView.play()
       }
    
    func loadSchedule(){
        // 時間割のデータ(NCMB)
        let query = NCMBQuery(className: "Data")
        // 自分の時間割だけ
        query?.whereKey("user", equalTo: NCMBUser.current())
        //一致するものは、1つであるはずなので、getFirstObjectでいい。
        query?.getFirstObjectInBackground({ (result, error) in
            
            // 授業情報のデータ(NCMB)
            let query2 = NCMBQuery(className: "subjects")
            
            if result  == nil {
                print("It is a new user!!")
            } else {
                // 時間割を一次元にした配列
                self.joined = (result as! NCMBObject).object(forKey: "selectSubject") as! [String]
                //equalToは１個しかとってこれないけど、containedInは一気にたくさんのデータをとってこれる
                // 時間割の配列はobjectIdが入っているので、授業名などに変換したい→その対応表がNCMBのsubjectsクラス
                // 自分の時間割に含まれる授業情報のみを取得
                query2?.whereKey("objectId", containedIn: self.joined)
                query2?.findObjectsInBackground({ (results, error) in
                    // とってきたデータを、辞書型に変換
                    //Dictionary型は[key:value]。keyは[文字列]を入れるとバリューが取り出せる。
                    var zDic = [String:String]()
                    for data in results as! [NCMBObject] {
                        //zDic[data.objectId:subjectName]
                        zDic[data.objectId] = data.object(forKey: "subjectName") as? String
                        print("zDicの中身は？*\(String(describing: zDic[data.objectId]))")
                    }
                    //map関数は配列から配列を作る。配列の一つ一つの要素に対して何か作用させて新しい配列を作る。
                    //($0=="") 左が条件。joinedの一つ一つのものに対して、何かを行なってドル0に代入する。左が条件がtrueだったらそれを返す。つまり、空。右側は入っているということ。
                    
                    
                    self.z = self.joined.map({ ($0=="") ? "" : zDic[$0]!})
                    self.filteredZ = self.z.filter{!$0.isEmpty}
                    
                    print("filteredZ:\(self.filteredZ)")
                    print("subjectInputTable.z\(self.z)")
                    print("subjectInputTable.joined\(self.joined)")
                    
                    // 色々やったけど、結局は[a, b, c]みたいなIDの配列を[数学, 英語, 体育]のような授業名の配列に変換したって感じ
                    self.tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                        HUD.hide(animated: true)
                    }
                })
            }
        })
        

    }
    
    

}


extension UIView {
    
    var top : CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var bottom : CGFloat{
        get{
            return frame.origin.y + frame.size.height
        }
        set{
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    var right : CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    var left : CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
}
