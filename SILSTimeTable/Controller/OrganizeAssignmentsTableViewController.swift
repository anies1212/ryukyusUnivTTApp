//
//  OrganizeAssignmentsTableViewController.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/11/22.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import PKHUD
import NCMB
import Floaty

class OrganizeAssignmentsTableViewController: UITableViewController {

    var todoList = ["今日の予定", "重要", "今後の予定", "全てのタスク"]
    var todoImageList = [UIImage(named: "study48"), UIImage(named: "star48"), UIImage(named: "calendar48"), UIImage(named: "task48")]
    var addTaskButton = Floaty()
    let paddingX: CGFloat = 10
    let paddingY: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //　ナビゲーションバーの背景色
//        navigationController?.setNavigationBarHidden(true, animated: false)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        UINavigationBar.appearance().barTintColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
//        tableView.backgroundColor = #colorLiteral(red: 0.9238761067, green: 0.998118937, blue: 0.9513512254, alpha: 1)
        
        tableView.separatorStyle = .none
        let nib = UINib( nibName:"OrganizeAssignmentsTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 70
        if let user = NCMBUser.current(){
//            title = "\(user.object(forKey: "userName") as! String)さんのToDoリスト"
            title = ""
        } else {
            print("error")
        }
        
        // 右側からの余白
        addTaskButton.paddingX = paddingX
        // 下側からの余白
        addTaskButton.paddingY = paddingY
        addTaskButton.fabDelegate = self
        addTaskButton.sticky = true
        self.view.addSubview(addTaskButton)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //　ナビゲーションバーの背景色
//        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // ボタンのインスタンス生成
//        let button = UIButton()
//        button.frame = CGRect(x:10, y:0,
//                              width:60, height:60)
//        button.setTitle("", for:UIControl.State.normal)
//        button.setImage(UIImage(named:"backArrow35"), for: .normal)
//        button.addTarget(self,
//                         action: #selector(backButton(_:)),
//                         for: .touchUpInside)
//        self.view.bringSubviewToFront(button)
//        self.view.addSubview(button)
        

    }
    
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "Segue", sender: nil)
            
        } else if indexPath.row == 1{
            self.performSegue(withIdentifier: "Segue2", sender: nil)
        } else if indexPath.row == 2{
            self.performSegue(withIdentifier: "Segue3", sender: nil)
            
        } else if indexPath.row == 3{
            self.performSegue(withIdentifier: "Segue4", sender: nil)
        } else {
            print ("error")
            HUD.show(.error)
        }
    }
    
    @objc func backButton (_ sender: UIButton){
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        print("backbuttondidtapped")
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))

        let imageview = UIImageView(image: UIImage(named: "toDoBackground.jpg"))
        header.addSubview(imageview)
//        imageview.frame = CGRect(x: 5, y: -10, width: 240, height: 140)
        imageview.frame = CGRect(x: (view.frame.size.width/2)-50, y: -10, width: 240, height: 140)
//        imageview.frame = CGRect(x: 0, y: -20, width: header.frame.size.width, height: 100)
        imageview.alpha = 0.5
        
        imageview.layer.cornerRadius = 10
//        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        
        let label = UILabel(frame: CGRect(x: 15, y: 15, width: imageview.frame.size.width-10, height: 100))
        

        if let user = NCMBUser.current(){
            label.text = """
\(user.object(forKey: "userName") as! String)さんの
タスクを整理しましょう。
"""
        } else {
            print("error")
        }
        

        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        header.addSubview(label)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrganizeAssignmentsTableViewCell
        cell.titleLabel.text = todoList[indexPath.row]
        cell.todoImage.image = todoImageList[indexPath.row]
        //これでセルをタップ時、色は変化しなくなる
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        return cell
        
    }

}
// MARK: - FloatyDelegate
extension OrganizeAssignmentsTableViewController: FloatyDelegate {

    func emptyFloatySelected(_ floaty: Floaty) {
        print("floatyTapped")
        let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "addTaskVC") as! AddTaskToCalendarViewController
        self.present(addTaskVC, animated: true, completion: nil)
    }
}
