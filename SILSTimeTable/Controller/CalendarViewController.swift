//
//  CalendarViewController.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/09/18.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import FSCalendar
import NCMB
import PKHUD
import CalculateCalendarLogic
import DZNEmptyDataSet


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegateAppearance, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var selectedDateLabel: UILabel!
    var selectedDate: Date!
    var selectedDateString: String!
    var lists = [NCMBObject]()
    var allDots = [NCMBObject]()
    @IBOutlet var todayButton: UIButton!
//    var cellIndex: IndexPath!
    @IBOutlet var crossButton: UIButton!
    
    // MARK: 1日目と2日目
    var firstDate: Date?
    var secondDate: Date?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendar.delegate = self
        calendar.dataSource = self
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.emptyDataSetSource = self
        taskTableView.emptyDataSetDelegate = self
        taskTableView.rowHeight = 70
        taskTableView.tableFooterView = UIView()
        taskTableView.separatorStyle = .none
        let nib = UINib(nibName: "CalendarTableViewCell", bundle: Bundle.main)
        taskTableView.register(nib, forCellReuseIdentifier: "Cell")
        //　ナビゲーションバーの背景色
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
        ]

        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        setLeftBarButtonItems()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        
        // その日のデータを取得し、最初からラベルに表示
        let now = Date()
        selectedDate = now
        selectedDateString = getDate(now)
        selectedDateLabel.text = selectedDateString
        if judgeHoliday(now) {
            calendar.appearance.titleTodayColor = .white
        }
        
        let font1 = UIFont(name: "ArialMT", size: 17)
        selectedDateLabel.font = font1
        
        todayButton.layer.cornerRadius = 5
        
        //tableViewのデータをロードする
        loadList()
        //Dotsのデータをロードする
        loadForDots()
        
        calendar.reloadData()

        calendar.layoutSubviews()
        taskTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        // 2.影の設定
        // 影の濃さ
        todayButton.layer.shadowOpacity = 0.1
        // 影のぼかしの大きさ
        todayButton.layer.shadowRadius = 2
        // 影の色
        todayButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        todayButton.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadForDots()
        calendar.reloadData()
    }


    
    override func viewWillAppear(_ animated: Bool) {
        //tableViewのデータをロードする
        loadList()
        //Dotsのデータをロードする
        loadForDots()
        
        calendar.reloadData()
        
        //祝祭日を色つけする
        let ud = UserDefaults.standard
        let firstWeekday = ud.integer(forKey: "firstWeekday") + 1
        if  firstWeekday != 0 {
            calendar.firstWeekday = UInt(firstWeekday)
        }
        print(firstWeekday)
        
        calendar.layoutSubviews()
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        selectedDate = date
        selectedDateString = getDate(date)
        //日付の表示
        selectedDateLabel.text = selectedDateString
        var datesArray:Array = [""]
        datesArray.append(selectedDate.description)
        print("datesArray:\(datesArray)")
        loadList()
    }
    
    
    // 日付String取得
    func getDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // TableViewのデータ表示
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    //TableViewのデータを取得し、表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CalendarTableViewCell
        let title = lists[indexPath.row].object(forKey: "taskTitle") as? String
        let inputtedSubject = lists[indexPath.row].object(forKey: "InputtedSubject") as? String
        cell.inputtedSubjectLabel.text = inputtedSubject
        cell.taskTitleLabel.text = title
        if lists[indexPath.row].object(forKey: "startlineDate") != nil {
            let startline = lists[indexPath.row].object(forKey: "startlineDate") as! Date
//            let deadline = lists[indexPath.row].object(forKey: "deadlineDate") as! Date
            cell.deadlineLabel.text = getTime(startline)
        }
        
        //これでセルをタップ時、色は変化しなくなる
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        let selectedItem = self.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        selectedItem.deleteInBackground { (error) in
            if error != nil{
                print("error")
                HUD.show(.error)
            } else {
                print("deleteSucceed")
                self.loadForDots()
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
    
    func loadForDots() {
        let query = NCMBQuery(className: "TasksData")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("startlineDateString", notEqualTo: nil)

        query?.findObjectsInBackground({ result, error in
            if error != nil {
                HUD.show(.error)
                return
            }
            self.allDots = result as! [NCMBObject]
            self.calendar.reloadData()
        })
    }
    
    
    //予定がある日にDotをつける
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
        var hasEvent = false
        let formattedDate = getDate(date)
        for object in allDots {
            var flag = true
            var datedayo =  object.object(forKey: "startlineDate") as! Date
            while flag{
                if getDate(datedayo) == formattedDate{
                    hasEvent = true
                }
                
                if datedayo >= object.object(forKey: "deadlineDate") as! Date{
                    flag = false
                }
                datedayo = Calendar.current.date(byAdding: .day, value: 1, to: datedayo)!
            }
        }
        if hasEvent {
            return 1
        } else {
            return 0
        }
    }
    
    
    // tableViewのリストをロードする
    func loadList() {
        
        self.lists = []
        //selectedDateString
        let formattedDate = selectedDateString
        for object in allDots {
            var hasEvent = false
            var flag = true
            var datedayo =  object.object(forKey: "startlineDate") as! Date
            while flag{
                if getDate(datedayo) == formattedDate{
                    hasEvent = true
                }
                
                if datedayo >= object.object(forKey: "deadlineDate") as! Date{
                    flag = false
                }
                datedayo = Calendar.current.date(byAdding: .day, value: 1, to: datedayo)!
            }
            if hasEvent{
                lists.append(object)
            }
            
        }
        self.taskTableView.reloadData()
        
//        let query = NCMBQuery(className: "TasksData")
//        query?.whereKey("user", equalTo: NCMBUser.current())
//        query?.whereKey("startlineDateString", equalTo: selectedDateString)
//        query?.order(byAscending: "startlineDate")
//        query?.findObjectsInBackground({ result, error in
//            if error != nil {
//                HUD.show(.error)
//                return
//            }
//            if result as! [NCMBObject] == []{
//                let query2 = NCMBQuery(className: "TasksData")
//                query2?.whereKey("user", equalTo: NCMBUser.current())
//                query2?.whereKey("deadlineDateString", equalTo: self.selectedDateString)
//                print("selectedDateString:\(String(describing: self.selectedDateString))")
//                query2?.order(byAscending: "deadlineDate")
//                query2?.findObjectsInBackground({ result2, error in
//                    if error != nil{
//                        print(error?.localizedDescription as Any)
//                    } else {
//                        print("deadLineResult:\(String(describing: result2))")
//                        self.lists = result2 as! [NCMBObject]
//                        print("self.lists:\(self.lists)")
//                        self.taskTableView.reloadData()
//                    }
//                })
//                return
//            }
//            self.lists = result as! [NCMBObject]
//            print("self.lists:\(self.lists)")
//            self.taskTableView.reloadData()
//        })
    }
    
    
    // なんかよくわかんないけど日付に赤青の色付け
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }

        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        } else if weekday == 7 {  //土曜日
            return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        }
            return nil
        }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 選択日を今日に移動
    @IBAction func today() {
        calendar.select(Date())
        selectedDate = Date()
        selectedDateString = getDate(Date())
        selectedDateLabel.text = getDate(Date())
        loadList()
    }
    
    // 詳細表示画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailViewController = segue.destination as! DetailTaskViewController
            let  selectedIndex = taskTableView.indexPathForSelectedRow
            detailViewController.selectedTask = lists[selectedIndex!.row]
        }
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        let image = UIImage(named: "clip-studying-at-home.png")
        
        // 画面の縦幅・横幅を取得
        let viewWidth: CGFloat = self.view.frame.size.width
        let viewHeight: CGFloat = self.view.frame.size.height
        // サイズを定義する
        let Resize:CGSize = CGSize.init(width: viewWidth/2.5, height:viewHeight/2.5)
        //UIImageを指定のサイズにリサイズ
        let imageResize = image?.resize(size: Resize)
        
        return imageResize
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string:
        """
        タスクが表示されます！
        ＋ボタンから追加しよう！
        """,
                                  attributes: [
                                    .foregroundColor: UIColor.gray,
                                    .font: UIFont.boldSystemFont(ofSize: 10)
                                  ])
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -25
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    

}
//UIImage リサイズ
extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
