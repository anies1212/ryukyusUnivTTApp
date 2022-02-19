//
//  ViewController.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/05/31.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import Lottie
import GoogleMobileAds // 追加
import RKNotificationHub
import CalculateCalendarLogic
import FSCalendar

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate,GADBannerViewDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UIScrollViewDelegate{
    
    lazy var loadingView: AnimationView = {
        let animationView = AnimationView(name: "loadAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1

        return animationView
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var leftItem: UIBarButtonItem!
    @IBOutlet var timeTableCollectionView: UICollectionView!
    @IBOutlet var friLabel: UILabel!
    @IBOutlet var thuLabel: UILabel!
    @IBOutlet var wedLabel: UILabel!
    @IBOutlet var tueLabel: UILabel!
    @IBOutlet var monLabel: UILabel!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var forthLabel: UILabel!
    @IBOutlet var fifthLabel: UILabel!
    @IBOutlet var sixthLabel: UILabel!
    @IBOutlet var bannerTappedButton: UIButton!
    @IBOutlet var selectedDateLabel: UILabel!
    @IBOutlet var calendarTitlelabel: UILabel!
    var selectedDateString = String()
    var notificationHub : RKNotificationHub?
    var info : UIButton? = nil
    var infoLists = [NCMBObject]()
    var allDots = [NCMBObject]()

//    @IBOutlet weak var timeTableCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var window: UIWindow?
    var bannerView: GADBannerView!  //追加
    @IBOutlet var bannerImageView: UIImageView!
    // 時間割の配列
    var subjects = [Class]()
    
    // 時間割のグリッドを計算するのに使ってるみたい(？)
    var selectedCollectionView =
        [[0,1,2,3,4],[5,6,7,8,9],[10,11,12,13,14],[15,16,17,18,19],[20,21,22,23,24],[25,26,27,28,29]]
    
    // 5曜日×6限の二次元配列
    var x =
        [["","","","",""],["","","","",""],["","","","",""],["","","","",""],["","","","",""],["","","","",""]]
    
    // collectionに表示させるための一次元配列
    var z =  ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    var y = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
//    var colorArray = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    var rereceiveColorArray = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    var sendAttendanceData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var sendAbsentData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var sendLateData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  
    var giveselectedCollectionView: Int!
    var receivedClass: String!
    var receivedData = ""
    var recievedSelectedCollectionView: String!
    var receivedWhereRow: Int!
    var receivedsetArrayIndexItem = [Int]()
    var userCheck = 0
    var selectedDate: Date!
    
    // 最終的に表示させるときに使う一次元配列
    var joined =  ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    
    var selectedIndexPath: String?
    var subjectName: String!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserName()
        self.navigationItem.titleView = UIImageView(image: UIImage (named:"ClassistLogoNavBar.png"))
        scrollView.delegate = self
        // スクロールビューのコンテンツサイズを指定
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 2,
                                        height: scrollView.frame.size.height)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        // その日のデータを取得し、最初からラベルに表示
        let now = Date()
        selectedDate = now
        selectedDateString = getDate(now)
        selectedDateLabel.text = selectedDateString
        if judgeHoliday(now) {
            calendar.appearance.titleTodayColor = .white
        }
        
        

        transitionCoordinator?.animate(alongsideTransition: { _ in
            let appearance = UINavigationBarAppearance()
//            appearance.backgroundColor = #colorLiteral(red: 0.7546748519, green: 0.6017797589, blue: 0.8982691765, alpha: 1)
            appearance.backgroundColor = UIColor.white
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
            ]
            appearance.shadowColor = UIColor.white
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.standardAppearance = appearance
        }, completion: { _ in
            let appearance = UINavigationBarAppearance()
//            appearance.backgroundColor = #colorLiteral(red: 0.7546748519, green: 0.6017797589, blue: 0.8982691765, alpha: 1)
            appearance.backgroundColor = UIColor.white
            appearance.shadowColor = UIColor.white
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                
            ]
            
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.standardAppearance = appearance
        })
        
        
        
        setRightNavItem()

        timeTableCollectionView.delegate = self
        timeTableCollectionView.dataSource = self
                
        let layoutSize = UICollectionViewFlowLayout()
        layoutSize.itemSize = CGSize(width: timeTableCollectionView.frame.width / 6, height: timeTableCollectionView.frame.height / 7.6)
        layoutSize.sectionInset = UIEdgeInsets(top: 3, left: 2, bottom: 12, right: 7.5)
        timeTableCollectionView.collectionViewLayout = layoutSize
//        timeTableCollectionViewFlowLayout.estimatedItemSize = CGSize(width: timeTableCollectionView.frame.width / 5.8, height: timeTableCollectionView.frame.height / 8.8)
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        

        bannerTappedButton.setTitle("", for: .normal)
        //色情報を取得
        fetchColorDataFromNCMB()
        reloadInfoBadge()

        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        //これを追加
        bannerView.delegate = self
        
//        bannerImageView.isUserInteractionEnabled = true
//        bannerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bannerTapped(_:))))
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        pageControl.isUserInteractionEnabled = false

    }
    
    @IBAction func bannerViewTapped(){
        let url = URL(string: "https://www.ekka.co.jp/recruit/?utm_source=app&utm_medium=banner&utm_campaign=ryukyu_calendar_app")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }


    
    
    override func viewWillAppear(_ animated: Bool) {
        
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        
        
        setRightNavItem()
        //色情報を取得
        fetchColorDataFromNCMB()
        reloadInfoBadge()
        // 二次元配列であるxを一次元配列に変換→collectionViewで表示させやすい形にしている
        let flatMapped = x.flatMap { value in
            value
        }
        joined = Array(x.joined())
        
        // 時間割のデータを更新
        loadSchedule()
        
        
        //細かな時間の取得
        
        let now = NSDate()
        let date = DateFormatter()
        date.dateFormat = "HH:mm:ss"
        let string = date.string(from: now as Date)
        
        if "08:30:00" <= string && string <= "10:00:00" {
            
            let font = UIFont(name: "Arial-BoldItalicMT", size: 20)
            firstLabel.font = font
            
        } else if "10:20:01" <= string && string <= "11:50:00"{
           
            let font = UIFont(name: "Arial-BoldItalicMT", size: 20)
            secondLabel.font = font
            
        } else if "12:50:01" <= string && string <= "14:20:00"{
         
            let font = UIFont(name: "Arial-BoldMT", size: 20)
            thirdLabel.font = font
            
        } else if "14:40:01" <= string && string <= "16:10:00"{
          
            let font = UIFont(name: "Arial-BoldMT", size: 20)
            forthLabel.font = font
            
        } else if "16:20:00" <= string && string <= "17:50:00"{
          
            let font = UIFont(name: "Arial-BoldMT", size: 20)
            fifthLabel.font = font
            
        } else if "18:00:00" <= string && string <= "19:30:00"{
        
            let font = UIFont(name: "Arial-BoldMT", size: 20)
            sixthLabel.font = font
        } else {
            print("授業はないよ")
        }
        

        
        //カレンダーにて日時を取得
        let calendar = Calendar.current
        
        //カレンダーにて日時情報を取得し、曜日に条件分岐
        enum WeekDay: Int {
            case sunday = 1
            case monday = 2
            case tuesday = 3
            case wednesday = 4
            case thursday = 5
            case friday = 6
            case saturday = 7
        }

        let comp = Calendar.Component.weekday
        let time = Calendar.Component.hour
        
        //1が日曜日7が土曜日で帰ってくる
        let weekday = WeekDay(rawValue: NSCalendar.current.component(comp, from: NSDate() as Date))!

        switch weekday {
        case .sunday:
            print("日曜日")
        case .monday:
            print("月曜日")
            let font = UIFont(name: "Arial-BoldMT", size: 20)
            monLabel.font = font
            

        case .tuesday:
            print("火曜日")
            let font = UIFont(name: "Arial-BoldMT", size: 20)
            tueLabel.font = font
            

        case .wednesday:
            print("水曜日")
            let font = UIFont(name: "Arial-BoldMT", size: 20)
            wedLabel.font = font
            

        case .thursday:
            print("木曜日")
            let font = UIFont(name: "Arial-BoldMT", size: 20)
            thuLabel.font = font
            
            
        case .friday:
            print("金曜日")
            let font = UIFont(name: "Arial-BoldMT", size: 20)
            friLabel.font = font

        case .saturday:
            print("土曜日")
            
        case .sunday:
            print("日曜日")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

        
        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = #colorLiteral(red: 0.7546748519, green: 0.6017797589, blue: 0.8982691765, alpha: 1)
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
        ]

        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 遷移後の画面の為にここで設定

        
        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = #colorLiteral(red: 0.7546748519, green: 0.6017797589, blue: 0.8982691765, alpha: 1)
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
        ]

        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    


    
    func setRightNavItem(){
        let infoButton = UIButton.init(type: .custom)
        infoButton.setImage(#imageLiteral(resourceName: "notification_bell").withRenderingMode(.alwaysTemplate), for: .normal)
        infoButton.addTarget(self, action: #selector(onInfo), for: .touchUpInside)
        
//        infoButton.tintColor = .systemBlue
        infoButton.tintColor = #colorLiteral(red: 0.7546748519, green: 0.6017797589, blue: 0.8982691765, alpha: 1)
        
        self.info = infoButton
        
        let stackview = UIStackView.init(arrangedSubviews: [infoButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 12
        let rightBarButton = UIBarButtonItem(customView: stackview)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    

    
    // 6限分(セクション=横一列)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    // 1セクションの中には月曜日〜金曜日の5要素が入る
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return selectedCollectionView[0].count
        case 1:
            return selectedCollectionView[1].count
        case 2:
            return selectedCollectionView[2].count
        case 3:
            return selectedCollectionView[3].count
        case 4:
            return selectedCollectionView[4].count
        case 5:
            return selectedCollectionView[5].count
     
        default:
            return 0
        }
    }
    
    
    // セルの内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = timeTableCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        
        cell.whereRow = receivedWhereRow
        
        cell.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 3
        
        
        
        switch indexPath.section {
        
        
        // 一行目(月曜1限,火曜1限,水曜1限,木曜1限,金曜1限)
        case 0:
            
            cell.subjectsLabel.text = z[indexPath.item]
            cell.subjectsLabel.adjustsFontSizeToFitWidth = true
//            print("z[indexPath.item]\(z)")
            cell.classRoomPlaceLabel.text = y[indexPath.item]
            cell.classRoomPlaceLabel.adjustsFontSizeToFitWidth = true
//            print("y[indexPath.item]\(y[indexPath.item])"
            
            if z[indexPath.item].isEmpty == true{
                cell.backgroundColor = #colorLiteral(red: 0.9675390124, green: 0.9720161557, blue: 0.9829614758, alpha: 1)
            } else if rereceiveColorArray[indexPath.item] == "blue"{
                cell.backgroundColor = #colorLiteral(red: 0.8424834609, green: 0.9819913507, blue: 1, alpha: 1)
            } else if rereceiveColorArray[indexPath.item] == "orange"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
            } else if rereceiveColorArray[indexPath.item] == "pink"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9086376429, blue: 0.9979354739, alpha: 1)
            } else if rereceiveColorArray[indexPath.item] == "green"{
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            }

            if y[indexPath.item].isEmpty == false && cell.classRoomPlaceLabel.text?.isEmpty == false{
                cell.classRoomPlaceLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else {
                cell.classRoomPlaceLabel.backgroundColor = .clear
            }
            
            return cell
         
        // 二行目(月曜2限,火曜2限,水曜2限,木曜2限,金曜2限)
        case 1:
            // セクションが変わるとindexpathも振り出しに戻るから、+5で無理やり先に進めている
            cell.subjectsLabel.text = self.z[indexPath.item+5]
            cell.subjectsLabel.adjustsFontSizeToFitWidth = true
            cell.classRoomPlaceLabel.text = y[indexPath.item+5]
            cell.classRoomPlaceLabel.adjustsFontSizeToFitWidth = true
            if z[indexPath.item+5].isEmpty == true{
                cell.backgroundColor = #colorLiteral(red: 0.9675390124, green: 0.9720161557, blue: 0.9829614758, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+5] == "blue"{
                cell.backgroundColor = #colorLiteral(red: 0.8424834609, green: 0.9819913507, blue: 1, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+5] == "orange"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+5] == "pink"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9086376429, blue: 0.9979354739, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+5] == "green"{
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            }

            if y[indexPath.item+5].isEmpty == false && cell.classRoomPlaceLabel.text?.isEmpty == false{
                cell.classRoomPlaceLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else {
                cell.classRoomPlaceLabel.backgroundColor = .clear
            }

            return cell
           
        // 以下同様
        case 2:
            
            cell.subjectsLabel.text = self.z[indexPath.item+10]
            cell.subjectsLabel.adjustsFontSizeToFitWidth = true
            cell.classRoomPlaceLabel.text = y[indexPath.item+10]
            cell.classRoomPlaceLabel.adjustsFontSizeToFitWidth = true
            if z[indexPath.item+10].isEmpty == true{
                cell.backgroundColor = #colorLiteral(red: 0.9675390124, green: 0.9720161557, blue: 0.9829614758, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+10] == "blue"{
                cell.backgroundColor = #colorLiteral(red: 0.8424834609, green: 0.9819913507, blue: 1, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+10] == "orange"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+10] == "pink"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9086376429, blue: 0.9979354739, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+10] == "green"{
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            }

            if y[indexPath.item+10].isEmpty == false && cell.classRoomPlaceLabel.text?.isEmpty == false{
                cell.classRoomPlaceLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else {
                cell.classRoomPlaceLabel.backgroundColor = .clear
            }

            return cell
            
        case 3:
            
            cell.subjectsLabel.text = self.z[indexPath.item+15]
            
            cell.classRoomPlaceLabel.text = y[indexPath.item+15]
            cell.classRoomPlaceLabel.adjustsFontSizeToFitWidth = true
            if z[indexPath.item+15].isEmpty == true{
                cell.backgroundColor = #colorLiteral(red: 0.9675390124, green: 0.9720161557, blue: 0.9829614758, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+15] == "blue"{
                cell.backgroundColor = #colorLiteral(red: 0.8424834609, green: 0.9819913507, blue: 1, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+15] == "orange"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+15] == "pink"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9086376429, blue: 0.9979354739, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+15] == "green"{
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            }
            
            if y[indexPath.item+15].isEmpty == false && cell.classRoomPlaceLabel.text?.isEmpty == false{
                cell.classRoomPlaceLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else {
                cell.classRoomPlaceLabel.backgroundColor = .clear
            }

            return cell
            
        case 4:
            
            cell.subjectsLabel.text = self.z[indexPath.item+20]
            cell.subjectsLabel.adjustsFontSizeToFitWidth = true
            cell.classRoomPlaceLabel.text = y[indexPath.item+20]
            cell.classRoomPlaceLabel.adjustsFontSizeToFitWidth = true
            if z[indexPath.item+20].isEmpty == true{
                cell.backgroundColor = #colorLiteral(red: 0.9675390124, green: 0.9720161557, blue: 0.9829614758, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+20] == "blue"{
                cell.backgroundColor = #colorLiteral(red: 0.8424834609, green: 0.9819913507, blue: 1, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+20] == "orange"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+20] == "pink"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9086376429, blue: 0.9979354739, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+20] == "green"{
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            }
            
            if y[indexPath.item+20].isEmpty == false && cell.classRoomPlaceLabel.text?.isEmpty == false{
                cell.classRoomPlaceLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else {
                cell.classRoomPlaceLabel.backgroundColor = .clear
            }
            
            return cell
            
        case 5:
            
            cell.subjectsLabel.text = self.z[indexPath.item+25]
            cell.subjectsLabel.adjustsFontSizeToFitWidth = true
            cell.classRoomPlaceLabel.text = y[indexPath.item+25]
            cell.classRoomPlaceLabel.adjustsFontSizeToFitWidth = true
            if z[indexPath.item+25].isEmpty == true{
                cell.backgroundColor = #colorLiteral(red: 0.9675390124, green: 0.9720161557, blue: 0.9829614758, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+25] == "blue"{
                cell.backgroundColor = #colorLiteral(red: 0.8424834609, green: 0.9819913507, blue: 1, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+25] == "orange"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9332814813, blue: 0.698238194, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+25] == "pink"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.9086376429, blue: 0.9979354739, alpha: 1)
            } else if rereceiveColorArray[indexPath.item+25] == "green"{
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.8601678014, green: 1, blue: 0.9228155613, alpha: 1)
            }
            
            if y[indexPath.item+25].isEmpty == false && cell.classRoomPlaceLabel.text?.isEmpty == false{
                cell.classRoomPlaceLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else {
                cell.classRoomPlaceLabel.backgroundColor = .clear
            }
            
            return cell
            
            
        default:

            return cell
            
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        


        
        // 何曜日何限目のセルがタップされたか検知
        func giveData(giveNum: Int){
            
            // 値渡しに使うため
            giveselectedCollectionView = selectedCollectionView[giveNum][indexPath.item]
            selectedIndexPath = joined[selectedCollectionView[giveNum][indexPath.item]]
    
        }
        
        switch indexPath.section {
        case 0:
            giveData(giveNum: 0)
        case 1:
            giveData(giveNum: 1)
        case 2:
            giveData(giveNum: 2)
        case 3:
            giveData(giveNum: 3)
        case 4:
            giveData(giveNum: 4)
        case 5:
            giveData(giveNum: 5)
                   
        default:
            break
        }
        


        switch indexPath.section {
        case 0:
            
            // 表示させる配列が空なら追加画面へ遷移
            if self.joined[indexPath.item].isEmpty == true{
                self.performSegue(withIdentifier: "Segue", sender: nil)
                
            } else {
                // 既に値が入っていれば詳細画面へ遷移
                performSegue(withIdentifier: "toDetail", sender: nil)
                
            }
            
        case 1:
            
            if self.joined[indexPath.item+5].isEmpty == true{
                self.performSegue(withIdentifier: "Segue", sender: nil)
            } else {
                performSegue(withIdentifier: "toDetail", sender: nil)
            }
            
        case 2:
            
            if self.joined[indexPath.item+10].isEmpty == true{
                self.performSegue(withIdentifier: "Segue", sender: nil)
            } else {
                performSegue(withIdentifier: "toDetail", sender: nil)
            }
            
        case 3:
            
            if self.joined[indexPath.item+15].isEmpty == true{
                self.performSegue(withIdentifier: "Segue", sender: nil)
            } else {
                performSegue(withIdentifier: "toDetail", sender: nil)
            }
            
        case 4:
            
            if self.joined[indexPath.row+20].isEmpty == true{
                self.performSegue(withIdentifier: "Segue", sender: nil)
                
            } else {
                performSegue(withIdentifier: "toDetail", sender: nil)
            }
            
        case 5:
            
            if self.joined[indexPath.row+25].isEmpty == true{
                self.performSegue(withIdentifier: "Segue", sender: nil)
            } else {
                performSegue(withIdentifier: "toDetail", sender: nil)
            }
            
        default:
           
           break
            
        }
    }
    
    func fetchUserName(){
        if let user = NCMBUser.current(){
            calendarTitlelabel.text = "\(user.object(forKey: "userName") as! String)さんの今後の日程"
        } else {
            print("error")
        }
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
                    var yDic = [String:String]()
                    for data in results as! [NCMBObject] {
                        //zDic[data.objectId:subjectName]
                        zDic[data.objectId] = data.object(forKey: "subjectName") as? String
                        yDic[data.objectId] = data.object(forKey: "classPlace") as? String
                        print("zDicの中身は？*\(String(describing: zDic[data.objectId]))")
                        print("yDicの中身は？*\(String(describing: yDic[data.objectId]))")
                    }
                    //map関数は配列から配列を作る。配列の一つ一つの要素に対して何か作用させて新しい配列を作る。
                    //($0=="") 左が条件。joinedの一つ一つのものに対して、何かを行なってドル0に代入する。左が条件がtrueだったらそれを返す。つまり、空。右側は入っているということ。
                    
                    self.z = self.joined.map({ ($0=="") ? "" : zDic[$0]!})
                    print("self.z？\(self.z)")
                    self.y = self.joined.map({ ($0=="") ? "" : yDic[$0]!})
                    print("self.y\(self.y)")
 
                    // 色々やったけど、結局は[a, b, c]みたいなIDの配列を[数学, 英語, 体育]のような授業名の配列に変換したって感じ
                    self.timeTableCollectionView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                        HUD.hide(animated: true)
                        self.stopLoading()
                    }
                })
            }
        })
        

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue"{
            
            let selectSubjectVC = segue.destination as! SelectSubjectViewController
            
            // 何曜日何限がタップされたのかの情報を値渡し
            // そのセルに追加する
            selectSubjectVC.receiveRow = giveselectedCollectionView!
            selectSubjectVC.receiveJoined = joined
            
            
            
        } else if segue.identifier == "toDetail"{
            
            let detailVC = segue.destination as! DetailViewController
            detailVC.receiveSelectedCollectionViewCell = giveselectedCollectionView
            print("ここの値私ができていないと話にならない:\(giveselectedCollectionView)")

            detailVC.recieveJoinedIndexPath = selectedIndexPath

            // 時間割の配列も渡す→向こうのページで更新した後で保存するため
            detailVC.q = joined
            
            //            もし色配列が空でなければ、今の情報を渡す
            detailVC.receiveForColor = rereceiveColorArray
            detailVC.receiveAttendanceData = sendAttendanceData
            detailVC.receiveAbsentData = sendAbsentData
            detailVC.receiveLateData = sendLateData
            
        }
    }
    
    func fetchColorDataFromNCMB(){
//        HUD.show(.progress)
        startLoading()
            //colorArrayがすでにある場合、データを取得し、rereceiveに反映させる
        let query = NCMBQuery(className: "colorData")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ result, error in
            if error != nil{
                
                print("error")
                HUD.show(.error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let alert = UIAlertController(title: "ログアウトされました", message: "一度ログインし直してください", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    // 6秒後に実行したい処理
                    print("2秒後に実行")

                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "SignInVC")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    HUD.flash(.success)
                    
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
                
                //色の取得
            } else {
                let colors = result as! [NCMBObject]
                //resultでは["pink","","",""....]という感じでとってこれている。
                
                //色情報がないユーザーの場合の処理
                if colors.isEmpty == true {
                    print("New User")
                    let object = NCMBObject(className: "colorData")
                    object?.setObject(self.rereceiveColorArray, forKey: "colorArray")
                    object?.setObject(NCMBUser.current(), forKey: "user")
                    object?.saveInBackground({ (error) in
                        if error != nil{
                            HUD.show(.error)
                        } else {
                            print("success")
                        }
                    })
                    
                    //色情報ありのユーザーの処理
                } else {
                    let colorArray = colors.first?.object(forKey: "colorArray") as! [String]
                    self.rereceiveColorArray = colorArray
                    print("self.rereceiveColorArray:\(self.rereceiveColorArray)")
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            HUD.hide(animated: true)
            self.stopLoading()
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
    


      func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }

}
extension ViewController: UIPopoverPresentationControllerDelegate {
    // Phone で Popover を表示するために必要
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    

    
    @objc func onInfo(_ sender: UIButton){


        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Info") as! InfoTableViewController
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = sender.superview
        vc.popoverPresentationController?.sourceRect = sender.frame
        vc.preferredContentSize = CGSize(width: 300, height: 200)
        vc.popoverPresentationController?.permittedArrowDirections = .up // 矢印の向きを制限する場合
        vc.popoverPresentationController?.delegate = self // Phone で Popover を表示するために必要
        present(vc, animated: true)
    }
    
    private func reloadInfoBadge(){
        let query = NCMBQuery(className: "Info")
//        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("active", equalTo: true)
        query?.findObjectsInBackground({ result, error in
            if error != nil {
                HUD.show(.error)
                return
            }
            self.infoLists = result as! [NCMBObject]
            if self.infoLists.isEmpty == true{
                print("no new info")
            } else {
                let query = NCMBQuery(className: "infoUser")
                query?.whereKey("user", equalTo: NCMBUser.current())
                query?.findObjectsInBackground({ result, error in
                    if error != nil{
                        print("error")
                    } else {
                        let infoUserReadCount = result as! [NCMBObject]
                        self.notificationHub = RKNotificationHub(view: self.info)
                        self.notificationHub?.setView(self.info, andCount: 1)
                        self.notificationHub?.count = Int32(self.infoLists.count - infoUserReadCount.count)
                        self.notificationHub?.moveCircleBy(x: 0, y: 0)
                        self.notificationHub?.scaleCircleSize(by: 0.6)
                        self.notificationHub?.setCircleColor(UIColor.init(red: 237/255, green: 73/255, blue: 86/255, alpha: 1), label: .white)
                        self.notificationHub?.pop()
                        self.notificationHub?.showCount()
                        //self.infoLists.count - self.infoUser.count
                    }
                })
                

            }
        })
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
        query?.whereKey("deadlineDateString", notEqualTo: nil)
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
            if object.object(forKey: "deadlineDateString") as! String == formattedDate {
                hasEvent = true
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
        let query = NCMBQuery(className: "TasksData")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("deadlineDateString", equalTo: selectedDateString)
        query?.order(byAscending: "deadlineDate")
        query?.findObjectsInBackground({ result, error in
            if error != nil {
                HUD.show(.error)
                return
            }
//            self.lists = result as! [NCMBObject]
//            print("self.lists:\(self.lists)")
//            self.taskTableView.reloadData()
        })
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
    
    // 日付String取得
    func getDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // 選択日を今日に移動
    @IBAction func today() {
        calendar.select(Date())
        selectedDate = Date()
        selectedDateString = getDate(Date())
        selectedDateLabel.text = getDate(Date())
        loadList()
    }
//    // tableViewのリストをロードする
//    func loadList() {
//        let query = NCMBQuery(className: "TasksData")
//        query?.whereKey("user", equalTo: NCMBUser.current())
//        query?.whereKey("deadlineDateString", equalTo: selectedDateString)
//        query?.order(byAscending: "deadlineDate")
//        query?.findObjectsInBackground({ result, error in
//            if error != nil {
//                HUD.show(.error)
//                return
//            }
//            self.lists = result as! [NCMBObject]
//            print("self.lists:\(self.lists)")
//            self.taskTableView.reloadData()
//        })
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectedDate = date
        selectedDateString = getDate(date)
        //日付の表示
        selectedDateLabel.text = selectedDateString
        loadList()
        
        
    }
    

}


