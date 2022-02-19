//
//  MenuViewController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/03.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import PKHUD
import NCMB

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet var progSchoolImageView: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    
    
    var menuBarItems = ["プロフィール", "ToDoリスト","カレンダー"]
    var menuBarImages = [UIImage(named: "profileNewImage2.jpg"), UIImage(named: "toDoNewImage2.jpg"), UIImage(named:"calendarNewImage2.jpg")]
    var explanationArray = ["自分のログアウト、アカウント削除の実行や自分の取得単位数が把握できるよ！", "自分がやるべきことを日付順に確認できる！", "今後の予定を確認したり、登録したりすることが可能だよ！"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .none
//        menuTableView.register(UINib(nibName: "AccountHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        let nib = UINib(nibName: "TableViewCell", bundle: Bundle.main)
        menuTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        
//        menuTableView.rowHeight = 100
//        menuTableView.backgroundColor = #colorLiteral(red: 0.9238761067, green: 0.998118937, blue: 0.9513512254, alpha: 1)
//        menuTableView.tableFooterView = UIView()
//        let footerView = UIView()
//        footerView.backgroundColor = .systemBlue
//        footerView.frame.size.height = 200
//        self.menuTableView.tableFooterView = footerView
 
//        let button = UIButton(type: .system)
//        button.setTitle("Menu", for: .normal)
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        let menuBarButtonItem = UIBarButtonItem(customView: button)
//        navigationItem.leftBarButtonItem = menuBarButtonItem
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.enableTransparency()
        
        UINavigationBar.appearance().barTintColor = UIColor.clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.enableTransparency()
        
        let menuPos = self.menuView.layer.position
        self.menuView.layer.position.x = -self.menuView.frame.width
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {self.menuView.layer.position.x = menuPos.x}, completion:  { (bool) in
            //
        })
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        navigationController?.navigationBar.enableTransparency()
        UINavigationBar.appearance().barTintColor = UIColor.clear
    }
    
    override func updateViewConstraints() {
           super.updateViewConstraints()
        navigationController?.navigationBar.enableTransparency()
           navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear] //タイトル色 白
        UINavigationBar.appearance().barTintColor = UIColor.clear
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.disableTransparency()
        navigationController?.navigationBar.enableTransparency()
        UINavigationBar.appearance().barTintColor = UIColor.clear
    }

    
    @IBAction func bannerViewTappedGesture(_ sender: Any) {
        let url = URL(string: "https://sites.google.com/view/classistprogrammingschool/%E3%83%9B%E3%83%BC%E3%83%A0")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {self.menuView.layer.position.x = -self.menuView.frame.width}, completion:  { (bool) in
                    self.dismiss(animated: true, completion: nil)
                    
                    })
                }
                
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuBarItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "こんにちは"
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))

        let imageview = UIImageView(image: UIImage(named: "christmasBack2.jpg"))
        header.addSubview(imageview)
        imageview.frame = CGRect(x: 5, y: -45, width: 240, height: 140)
//        imageview.frame = CGRect(x: 0, y: -20, width: header.frame.size.width, height: 100)

        imageview.layer.cornerRadius = 10
//        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        
        let label = UILabel(frame: CGRect(x: 15, y: -10, width: imageview.frame.size.width-10, height: 100))
        

        if let user = NCMBUser.current(){
            label.text = """
\(user.object(forKey: "userName") as! String)さん。
こんにちは
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "Segue", sender: nil)
            
        } else if indexPath.row == 1{
            self.performSegue(withIdentifier: "Segue2", sender: nil)
            
        } else if indexPath.row == 2{
            self.performSegue(withIdentifier: "Segue3", sender: nil)
        } else {
            print ("error")
            HUD.show(.error)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! MenuHeaderTableViewCell
//            return cell
//        }
        
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.menuBarLabel.text = menuBarItems[indexPath.row]
        cell.menuBarImageView.image = menuBarImages[indexPath.row]
        cell.explanationLabel.text = explanationArray[indexPath.row]
//        cell.layer.cornerRadius = 10
        cell.backgroundColor = #colorLiteral(red: 0.9137254902, green: 1, blue: 0.9607843137, alpha: 1)
        
        //これでセルをタップ時、色は変化しなくなる
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        cell.layer.masksToBounds = true
//        cell.backgroundColor = UIColor(red: 178/255, green: 129/255, blue: 224/255, alpha: 0.7)
        
        return cell
        
        
    }
    

    
    }

public extension UINavigationBar {
    /// ナビゲーションバーを透明化する
    func enableTransparency() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }

    /// ナビゲーションバーを透明化を解除する
    func disableTransparency() {
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
    }
}
    
    
    

    


