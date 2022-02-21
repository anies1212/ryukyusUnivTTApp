//
//  ImportantTasksTableViewController.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/11/24.
//  Copyright © 2021 Apple. All rights reserved.
//

//
//  TodayAssignmentsTableViewController.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/11/23.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import DZNEmptyDataSet
import Floaty


class ImportantTasksTableViewController: UITableViewController, ToDoTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    // この配列に作ったアイテムを追加していく
    var selectedIndex: IndexPath!
    var lists = [NCMBObject]()
    var tapped = false
    @IBOutlet var crossButton: UIButton!
    var selectedDate: Date!
    var selectedDateString: String!
    let paddingX: CGFloat = 10
    let paddingY: CGFloat = 100
    var addTaskButton = Floaty()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //        loadData()
//        crossButton.setTitle("", for: .normal)
//        crossButton.setImage(UIImage(named: "iconCancel25")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        crossButton.tintColor = UIColor(red: 178/255, green: 129/255, blue: 224/255, alpha: 1)
        
        let nib = UINib( nibName:"ToDoTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        selectedDateStringFunc()
        today()
        
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

        
        // 右側からの余白
        addTaskButton.paddingX = paddingX
        // 下側からの余白
        addTaskButton.paddingY = paddingY
        addTaskButton.fabDelegate = self
        addTaskButton.sticky = true
        self.view.addSubview(addTaskButton)

        // NaviBarのタイトルを大きく表示させ、スクロールした場合は小さくする
        //        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        // trueで複数選択、falseで単一選択
        tableView.allowsMultipleSelection = true
        //　ナビゲーションバーの背景色
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
//        appearance.titleTextAttributes = [
//            .foregroundColor: UIColor.black,
//        ]

//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.standardAppearance = appearance
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "ArialMT", size: 17)!]
//        setLeftBarButtonItems()
        
        loadList()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        UINavigationBar.appearance().barTintColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        selectedDateStringFunc()
        loadList()
        
    }
    
    func setLeftBarButtonItems(){
        crossButton = UIButton.init(type: .custom)
        crossButton.setTitle("", for: .normal)
        crossButton.setImage(UIImage(named: "iconCancel25")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        crossButton.tintColor = UIColor(red: 178/255, green: 129/255, blue: 224/255, alpha: 1)
        crossButton.tintColor = UIColor.systemBlue
        crossButton.addTarget(self, action: #selector(crossButtonFunc), for: .touchUpInside)
        let stackview = UIStackView.init(arrangedSubviews: [crossButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 12

        let leftBarButton = UIBarButtonItem(customView: stackview)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func crossButtonFunc(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func backButton (_ sender: UIButton){
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        print("backbuttondidtapped")
    }
    
    @objc func addButtonDidTapped (_ sender: UIButton){
        let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "addTaskVC") as! AddTaskToCalendarViewController
        self.present(addTaskVC, animated: true, completion: nil)
    }
    
    // TableViewのデータ表示
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    //TableViewのデータを取得し、表示
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ToDoTableViewCell
        cell.delegate = self
//
//        let deadline = lists[indexPath.row].object(forKey: "deadlineDateString") as? String
//        if deadline == selectedDateString{
            
            let title = lists[indexPath.row].object(forKey: "taskTitle") as? String
            let inputtedSubject = lists[indexPath.row].object(forKey: "InputtedSubject") as? String
            cell.toDoLabel.text = title
            cell.inputtedSubjectLabel.text = inputtedSubject
            if lists[indexPath.row].object(forKey: "deadlineDateString") != nil {
                let deadline = lists[indexPath.row].object(forKey: "deadlineDateString") as? String
                cell.deadLineLabel.text = deadline
            }
//        }
//        let title = lists[indexPath.row].object(forKey: "taskTitle") as? String
//        let inputtedSubject = lists[indexPath.row].object(forKey: "InputtedSubject") as? String
//        cell.inputtedSubjectLabel.text = inputtedSubject
//        cell.toDoLabel.text = title
//        if lists[indexPath.row].object(forKey: "deadlineDate") != nil {
////            let deadline = lists[indexPath.row].object(forKey: "deadlineDate") as? Date
//            let deadline = lists[indexPath.row].object(forKey: "deadlineDateString") as? String
////            cell.deadLineLabel.text = getTime(deadline)
//            cell.deadLineLabel.text = deadline
//        } else if lists[indexPath.row].object(forKey: "deadlineDate") == nil{
//            print("not today")
//        }
//                return cell
//                } else {
//            print("no todays assignments")
//        }


        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        let state = lists[indexPath.row].object(forKey: "state") as! Bool
        cell.checkState = state
        cell.cellIndex = indexPath
        if lists[indexPath.row].object(forKey: "starState") == nil{
            lists[indexPath.row].setObject(false, forKey: "starState")
        } else {
            let starState = lists[indexPath.row].object(forKey: "starState") as! Bool
            cell.starCheckState = starState
            cell.starCellIndex = indexPath
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        let imageview = UIImageView(image: UIImage(named: "isolationHeader"))
        imageview.alpha = 0.8
        header.addSubview(imageview)
        imageview.frame = CGRect(x: (view.frame.size.width/2)-50, y: -10, width: 240, height: 140)
        //        imageview.frame = CGRect(x: 0, y: -20, width: header.frame.size.width, height: 100)
        imageview.alpha = 0.8
        imageview.layer.cornerRadius = 10
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        
        let label = UILabel(frame: CGRect(x: 25, y: 15, width: imageview.frame.size.width-10, height: 100))
        
        // その日のデータを取得し、最初からラベルに表示
        let selectedDateLabel = UILabel()
        let now = Date()
        selectedDate = now
        selectedDateString = getDate(now)
        selectedDateLabel.text = selectedDateString
        let font1 = UIFont(name: "ArialMT", size: 17)
        selectedDateLabel.font = font1

        if let user = NCMBUser.current(){
            label.text = """
\(user.object(forKey: "userName") as! String)さんの
重要タスク
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
        
    
    // MARK: checkbutton
    func didTapCheckButton(button: UIButton, indexPath: IndexPath) {
        var state = lists[indexPath.row].object(forKey: "state") as! Bool
        state = !state
        lists[indexPath.row].setObject(state, forKey: "state")
        lists[indexPath.row].saveInBackground({ (error) in
            if error != nil {
                HUD.show(.error)
                return
            }
        })
        tableView.reloadData()
    }
    
    // MARK: checkbutton
    func didTapStarCheckButton(button: UIButton, indexPath: IndexPath) {
        var starState = lists[indexPath.row].object(forKey: "starState") as! Bool
        starState = !starState
        lists[indexPath.row].setObject(starState, forKey: "starState")
        lists[indexPath.row].saveInBackground({ (error) in
            if error != nil {
                HUD.show(.error)
                return
            }
        })
        tableView.reloadData()
    }
    
    func selectedDateStringFunc(){
        let now = Date()
        selectedDate = now
        selectedDateString = getDate(now)
    }

    
    // 詳細表示画面遷移
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    // 画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailViewController = segue.destination as! DetailTaskViewController
            let  selectedIndex = tableView.indexPathForSelectedRow
            detailViewController.selectedTask = lists[selectedIndex!.row]
        }
    }
    
    // 選択日を今日に移動
    func today() {
        selectedDate = Date()
        print("selectedDate:\(String(describing: selectedDate))")
        loadList()
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     
        let selectedItem = self.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        selectedItem.deleteInBackground { (error) in
            if error != nil{
                print(error)
                HUD.show(.error)
            } else {
                print("deleteSucceed")
            }
        }
    }

    //時間の取得
    func getTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // 日付String取得
    func getDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    

    // tableViewのリストをロードする
    func loadList() {
        let query = NCMBQuery(className: "TasksData")
        query?.whereKey("user", equalTo: NCMBUser.current())
//        query?.whereKey("deadlineDateString", equalTo: selectedDateString)
        query?.whereKey("starState", equalTo: true)
        query?.order(byAscending: "deadlineDate")
        query?.findObjectsInBackground({ result, error in
            if error != nil {
                HUD.show(.error)
                return
            }
            self.lists = result as! [NCMBObject]
            print("self.lists:\(self.lists)")
            self.tableView.reloadData()
        })
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        let image = UIImage(named: "ideaEmpty.png")
        
        // 画面の縦幅・横幅を取得
        let viewWidth: CGFloat = self.view.frame.size.width
        let viewHeight: CGFloat = self.view.frame.size.height
        // サイズを定義する
        let Resize:CGSize = CGSize.init(width: viewWidth/1.8, height:viewHeight/1.8)
        //UIImageを指定のサイズにリサイズ
        let imageResize = image?.resize(size: Resize)
        
        return imageResize
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string:
        """
        重要タスクが表示されます！
        重要なタスクにスターをつけよう！
        """,
                                  attributes: [
                                    .foregroundColor: UIColor.gray,
                                    .font: UIFont.boldSystemFont(ofSize: 15)
                                  ])
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 60
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    

}


// MARK: - FloatyDelegate
extension ImportantTasksTableViewController: FloatyDelegate {


    
    func emptyFloatySelected(_ floaty: Floaty) {
        print("floatyTapped")
        let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "addTaskVC") as! AddTaskToCalendarViewController
        self.present(addTaskVC, animated: true, completion: nil)
    }
}


