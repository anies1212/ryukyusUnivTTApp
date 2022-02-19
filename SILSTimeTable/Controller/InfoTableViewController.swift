//
//  InfoViewController.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/11/15.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import RKNotificationHub
import DZNEmptyDataSet

class InfoTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    var viewController : UIViewController? = nil
    var delegate: UIPopoverPresentationControllerDelegate?
    @IBOutlet var tableview: UITableView!
    var infoLists = [NCMBObject]()
    var infoUserLists = [NCMBObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.emptyDataSetSource = self
        self.tableview.emptyDataSetDelegate = self
        loadInfoList()
        let nib = UINib( nibName:"InfoTableViewCell", bundle: Bundle.main)
        tableview.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadInfoList()
    }
    
    // 詳細表示画面遷移
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return infoLists.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! InfoTableViewCell
        //        cell.delegate = self
        
        let title = infoLists[indexPath.row].object(forKey: "info") as? String
        cell.label.text = title
        
        cell.alreadyCheckedAction = { [weak self]  in
            //queryで、押されたセルのObjectIdを取得する
        
            let object = NCMBObject(className: "infoUser")
            object?.setObject(NCMBUser.current(), forKey: "user")
//            self.infoUserLists.append(self?.infoLists)
//            object?.setObject(self?.infoUserLists[indexPath.row], forKey: "Checked")
            object?.setObject(true, forKey: "Checked")
            object?.saveInBackground({ error in
                if error != nil{
                    print("error")
                } else {
                    print("succeed")
                }
            })
            cell.button.isEnabled = false
                            
        }
        return cell
    }
    

    
    
    
    // tableViewのリストをロードする
    func loadInfoList() {
        let query = NCMBQuery(className: "Info")
        //        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("active", equalTo: true)
        query?.order(byAscending: "info")
        query?.findObjectsInBackground({ result, error in
            if error != nil {
                HUD.show(.error)
                return
            }
            self.infoLists = result as! [NCMBObject]
            self.tableview.reloadData()
        })
    }

func loadInfoUserList(){
    let query = NCMBQuery(className: "infoUser")
    //        query?.whereKey("user", equalTo: NCMBUser.current())
    query?.order(byAscending: "infoUser")
    query?.findObjectsInBackground({ result, error in
        if error != nil {
            HUD.show(.error)
            return
        }
        self.infoUserLists = []
        self.infoUserLists = result as! [NCMBObject]
        self.tableview.reloadData()
    })
}

    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string:
                                    "特に追加情報はありません",
                                  attributes: [
                                    .foregroundColor: UIColor.gray,
                                    .font: UIFont.boldSystemFont(ofSize: 10)
                                  ])
    }



}
