//
//  ReviewViewController.swift
//  SILSTimeTable
//
//  Created by 新垣清奈 on 2021/09/15.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import Lottie

class ReviewViewController: UIViewController {
    
    lazy var loadingView: AnimationView = {
        let animationView = AnimationView(name: "loadAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }()
    
    lazy var animationView: AnimationView = {
        let animationView = AnimationView(name: "school")
        animationView.frame = CGRect(x: 0, y:self.view.frame.minY-60, width: self.view.bounds.width , height: 350)
        //        animationView.center = self.view.center
        animationView.loopMode = .loop
//        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }()
    
    lazy var animationView2: AnimationView = {
        let animationView = AnimationView(name: "schoolPeople")
        animationView.frame = CGRect(x: 0, y: self.view.frame.minY-60 , width: self.view.bounds.width , height: 400)
        //        animationView.center = self.view.center
        animationView.loopMode = .loop
//        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }()
    
    lazy var animationView3: AnimationView = {
        let animationView = AnimationView(name: "stayCreative")
        animationView.frame = CGRect(x: 0, y: self.view.frame.minY-60, width: self.view.bounds.width , height: 400)
        //        animationView.center = self.view.center
        animationView.loopMode = .loop
//        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }()
    
    
    
    @IBOutlet var subjectNameLabel: UILabel!
    @IBOutlet var subjectProfLabel: UILabel!
    @IBOutlet var subjectTimeLabel: UILabel!
    @IBOutlet var subjectPlaceLabel: UILabel!
    @IBOutlet var subjectCreditLabel: UILabel!
    @IBOutlet var severalMethodsScoringLabel: UILabel!
    @IBOutlet var attendantsCheckFrequencyLabel: UILabel!
    @IBOutlet var assignmentsCheckFrequencyLabel: UILabel!
    @IBOutlet var examFrequencyLabel: UILabel!
    @IBOutlet var starOne: UIImageView!
    @IBOutlet var starTwo: UIImageView!
    @IBOutlet var starThree: UIImageView!
    @IBOutlet var starFour: UIImageView!
    @IBOutlet var starFive: UIImageView!
    @IBOutlet var lectureLevelLabel: UILabel!
    @IBOutlet var assignmentsLevelLabel: UILabel!
    @IBOutlet var examsLevelLabel: UILabel!
    @IBOutlet var opinionTextView: UITextView!
    @IBOutlet var starHalfOne: UIImageView!
    @IBOutlet var starHalfTwo: UIImageView!
    @IBOutlet var starHalfThree: UIImageView!
    @IBOutlet var starHalfFour: UIImageView!
    @IBOutlet var starHalfFive: UIImageView!
    
    
    var receiveSubject: Class!
    var receiveSubjectFromDetail:Class!
    var randomNumber: Int!
    var recieveStar: String!
    var recieveStarFromDetail: String!
    var receiveStarFromSubject: String!
    var receiveCreditDifficultyNumFromDetail: String!
    var receiveCreditDifficultyNumFromSubject: String!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        configureSV()
        makeRandomNumber()
        
        startAnimation()
        startAnimation2()
        startAnimation3()
        
        if receiveSubjectFromDetail != nil{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.subjectNameLabel.text = self.receiveSubjectFromDetail.subjectName
                self.subjectProfLabel.text = self.receiveSubjectFromDetail.Prof
                self.subjectTimeLabel.text = self.receiveSubjectFromDetail.dayTime
                self.subjectPlaceLabel.text = self.receiveSubjectFromDetail.classPlace
                self.subjectCreditLabel.text = self.receiveSubjectFromDetail.creditNum
                self.recieveStarFromDetail = self.receiveSubjectFromDetail.star
                self.severalMethodsScoringLabel.text = self.receiveSubjectFromDetail.scoringMethod
                self.attendantsCheckFrequencyLabel.text = self.receiveSubjectFromDetail.attendantsCheckFrequency
                self.assignmentsCheckFrequencyLabel.text = self.receiveSubjectFromDetail.assignmentsCheckFrequency
                self.examFrequencyLabel.text = self.receiveSubjectFromDetail.examFrequency
                self.lectureLevelLabel.text = self.receiveSubjectFromDetail.lectureLevel
                self.assignmentsLevelLabel.text = self.receiveSubjectFromDetail.assignmentsLevel
                self.examsLevelLabel.text = self.receiveSubjectFromDetail.examsLevel
                self.opinionTextView.text = self.receiveSubjectFromDetail.opinion
                self.receiveCreditDifficultyNumFromDetail = self.receiveSubjectFromDetail.creditDifficultyStarNum
                //                print("self.receiveCreditDifficultyNumFromDetail:\(self.receiveCreditDifficultyNumFromDetail)")
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.subjectNameLabel.text = self.receiveSubject.subjectName
                self.subjectProfLabel.text = self.receiveSubject.Prof
                self.subjectTimeLabel.text = self.receiveSubject.dayTime
                self.subjectPlaceLabel.text = self.receiveSubject.classPlace
                self.subjectCreditLabel.text = self.receiveSubject.creditNum
                self.receiveStarFromSubject = self.receiveSubject.star
                self.severalMethodsScoringLabel.text = self.receiveSubject.scoringMethod
                self.attendantsCheckFrequencyLabel.text = self.receiveSubject.attendantsCheckFrequency
                self.assignmentsCheckFrequencyLabel.text = self.receiveSubject.assignmentsCheckFrequency
                self.examFrequencyLabel.text = self.receiveSubject.examFrequency
                self.lectureLevelLabel.text = self.receiveSubject.lectureLevel
                self.assignmentsLevelLabel.text = self.receiveSubject.assignmentsLevel
                self.examsLevelLabel.text = self.receiveSubject.examsLevel
                self.opinionTextView.text = self.receiveSubject.opinion
                self.receiveCreditDifficultyNumFromSubject = self.receiveSubject.creditDifficultyStarNum
                print("receiveCreditDifficultyNumFromSubject:\(self.receiveCreditDifficultyNumFromSubject)")
            }
        }
    }
    
    
    
    
    func createLabelSubjectName(contentsView: UIView) -> UILabel {
        
        // labelを作る
        subjectNameLabel = UILabel()
        subjectNameLabel.frame = CGRect(x: 23, y: 275, width: 347, height: 33)
        subjectNameLabel.font = UIFont.boldSystemFont(ofSize: 27)
        subjectNameLabel.textColor = UIColor.darkGray
        return subjectNameLabel
    }
    
    func createLabelSubjectTime(contentsView: UIView) -> UILabel {
        // labelを作る
        subjectTimeLabel = UILabel()
        subjectTimeLabel.font = UIFont.systemFont(ofSize: 16)
        subjectTimeLabel.textColor = UIColor.darkGray
        subjectTimeLabel.frame = CGRect(x: 70, y: 340, width: 128, height: 21)
        
        return subjectTimeLabel
    }
    
    func createLabelSubjectProf(contentsView: UIView) -> UILabel {
        // labelを作る
        subjectProfLabel = UILabel()
        subjectProfLabel.textColor = UIColor.darkGray
        subjectProfLabel.font = UIFont.systemFont(ofSize: 16)
        subjectProfLabel.frame = CGRect(x: 70, y: 384, width: 128, height: 17)
        
        return subjectProfLabel
    }
    
    func createLabelSubjectPlace(contentsView: UIView) -> UILabel {
        // labelを作る
        subjectPlaceLabel = UILabel()
        subjectPlaceLabel.textColor = UIColor.darkGray
        subjectPlaceLabel.font = UIFont.systemFont(ofSize: 16)
        subjectPlaceLabel.frame = CGRect(x: 255, y: 340, width: 121, height: 21)
        
        return subjectPlaceLabel
    }
    
    func createLabelSubjectCredits(contentsView: UIView) -> UILabel {
        // labelを作る
        subjectCreditLabel = UILabel()
        subjectCreditLabel.textColor = UIColor.darkGray
        subjectCreditLabel.font = UIFont.systemFont(ofSize: 16)
        subjectCreditLabel.frame = CGRect(x: 255, y: 384, width: 121, height: 17)
        
        return subjectCreditLabel
    }
    
    func createComprehensiveEvalutionLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let comprehensiveEvaluationLabel = UILabel()
        comprehensiveEvaluationLabel.textColor = UIColor.darkGray
        comprehensiveEvaluationLabel.font = UIFont.systemFont(ofSize: 22)
        comprehensiveEvaluationLabel.frame = CGRect(x: 31, y: 447, width: 116, height: 34)
        comprehensiveEvaluationLabel.text = "総合評価"
        
        return comprehensiveEvaluationLabel
    }
    
    func createScoringMethodLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let scoringMethodLabel = UILabel()
        scoringMethodLabel.textColor = UIColor.darkGray
        scoringMethodLabel.font = UIFont.systemFont(ofSize: 17)
        scoringMethodLabel.frame = CGRect(x: 34, y: 508, width: 72, height: 20)
        scoringMethodLabel.text = "採点方法"
        
        return scoringMethodLabel
    }
    
    func createSeveralMethodsScoringLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        severalMethodsScoringLabel = UILabel()
        severalMethodsScoringLabel.textColor = UIColor.darkGray
        severalMethodsScoringLabel.font = UIFont.systemFont(ofSize: 14)
        severalMethodsScoringLabel.frame = CGRect(x: 175, y: 510, width: 195, height: 17)
        //        severalMethodsScoringLabel.text = "loading"
        
        return severalMethodsScoringLabel
    }
    
    func createFrequencyLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let frequencyLabel = UILabel()
        frequencyLabel.textColor = UIColor.darkGray
        frequencyLabel.font = UIFont.systemFont(ofSize: 15)
        frequencyLabel.frame = CGRect(x: ((self.view.bounds.width-390)/2), y: 560, width: 390, height: 18)
        frequencyLabel.textAlignment = NSTextAlignment.center
        frequencyLabel.backgroundColor = #colorLiteral(red: 0.8862306476, green: 0.790310204, blue: 1, alpha: 1)
        frequencyLabel.text = "頻度"
        
        return frequencyLabel
    }
    
    func createAttendantsConfirmLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let attendantsConfirmLabel = UILabel()
        attendantsConfirmLabel.textColor = UIColor.darkGray
        attendantsConfirmLabel.font = UIFont.systemFont(ofSize: 12)
        attendantsConfirmLabel.frame = CGRect(x: ((self.view.bounds.width-340)/2), y: 589, width: 92, height: 20)
        attendantsConfirmLabel.textAlignment = NSTextAlignment.center
        attendantsConfirmLabel.text = "出席確認の頻度"
        
        return attendantsConfirmLabel
    }
    
    func createAssignmentsLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let assignmentsLabel = UILabel()
        assignmentsLabel.textColor = UIColor.darkGray
        assignmentsLabel.font = UIFont.systemFont(ofSize: 12)
        assignmentsLabel.frame = CGRect(x: ((self.view.bounds.width-65)/2), y: 589, width: 61.5, height: 20)
        assignmentsLabel.textAlignment = NSTextAlignment.center
        assignmentsLabel.text = "課題の頻度"
        //166
        return assignmentsLabel
    }
    
    func createTestLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let testLabel = UILabel()
        testLabel.textColor = UIColor.darkGray
        testLabel.font = UIFont.systemFont(ofSize: 12)
        testLabel.frame = CGRect(x: ((self.view.bounds.width+160)/2), y: 589, width: 89, height: 20)
        testLabel.textAlignment = NSTextAlignment.center
        testLabel.text = "テストの頻度"
        
        return testLabel
    }
    
    func createAttendantsCheckFrequencyLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        attendantsCheckFrequencyLabel = UILabel()
        attendantsCheckFrequencyLabel.textColor = UIColor.darkGray
        attendantsCheckFrequencyLabel.font = UIFont.systemFont(ofSize: 12)
        attendantsCheckFrequencyLabel.frame = CGRect(x: ((self.view.bounds.width-343)/2), y: 617, width: 92, height: 16)
        attendantsCheckFrequencyLabel.textAlignment = NSTextAlignment.center
        //        attendantsCheckFrequencyLabel.text = "loading"
        
        return attendantsCheckFrequencyLabel
    }
    
    func createAssignmentsCheckFrequencyLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        assignmentsCheckFrequencyLabel = UILabel()
        assignmentsCheckFrequencyLabel.textColor = UIColor.darkGray
        assignmentsCheckFrequencyLabel.font = UIFont.systemFont(ofSize: 12)
        assignmentsCheckFrequencyLabel.frame = CGRect(x: ((self.view.bounds.width-100)/2), y: 617, width: 103, height: 16)
        assignmentsCheckFrequencyLabel.textAlignment = NSTextAlignment.center
        //        assignmentsCheckFrequencyLabel.text = "loading"
        
        return assignmentsCheckFrequencyLabel
    }
    
    func createExamFrequencyLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        examFrequencyLabel = UILabel()
        examFrequencyLabel.textColor = UIColor.darkGray
        examFrequencyLabel.font = UIFont.systemFont(ofSize: 12)
        examFrequencyLabel.frame = CGRect(x: ((self.view.bounds.width+157)/2), y: 617, width: 89, height: 16)
        examFrequencyLabel.textAlignment = NSTextAlignment.center
        //        examFrequencyLabel.text = "loading"
        
        return examFrequencyLabel
    }
    
    func createTimeImageView(contentsView: UIView) -> UIImageView {
        let timeView:UIImage = UIImage(named: "time.png")!
        let timeImageView = UIImageView(image: timeView)
        let rect:CGRect =
        CGRect(x:26, y:334, width:34, height:34)
        timeImageView.frame = rect;
        
        return timeImageView
    }
    
    func createProfImageView(contentsView: UIView) -> UIImageView {
        let profView:UIImage = UIImage(named: "icons8-graduation-cap-50.png")!
        let profImageView = UIImageView(image: profView)
        let rect:CGRect =
        CGRect(x:26, y:376, width:34, height:34)
        profImageView.frame = rect;
        
        return profImageView
    }
    
    func createPlaceImageView(contentsView: UIView) -> UIImageView {
        let placeView:UIImage = UIImage(named: "icons8-school-building-30.png")!
        let placeImageView = UIImageView(image: placeView)
        let rect:CGRect =
        CGRect(x:210, y:334, width:34, height:34)
        placeImageView.frame = rect;
        
        return placeImageView
    }
    
    func createCreditsImageView(contentsView: UIView) -> UIImageView {
        let creditsView:UIImage = UIImage(named: "credits.png")!
        let creditsImageView = UIImageView(image: creditsView)
        let rect:CGRect =
        CGRect(x:210, y:376, width:34, height:34)
        creditsImageView.frame = rect;
        
        return creditsImageView
    }
    
    func createStarOneImageView(contentsView: UIView) -> UIImageView {
        let starOneImage:UIImage = UIImage(named: "icons8-スター-48.png")!
        self.starOne = UIImageView(image: starOneImage)
        let rect:CGRect =
        CGRect(x:171, y:446, width:34, height:34)
        self.starOne.frame = rect;
        
        return starOne
    }
    
    func createFilledStarOneImageView(contentsView: UIView) -> UIImageView {
        let starOneImage:UIImage = UIImage(named: "icons8-star-48.png")!
        self.starOne = UIImageView(image: starOneImage)
        let rect:CGRect =
        CGRect(x:171, y:446, width:34, height:34)
        self.starOne.frame = rect;
        
        return starOne
    }
    
    func createHalfStarOneImageView(contentsView: UIView) -> UIImageView {
        let starHalfOneImage:UIImage = UIImage(named: "starHalf.png")!
        starHalfOne = UIImageView(image: starHalfOneImage)
        let rect:CGRect =
        CGRect(x:171, y:446, width:34, height:34)
        self.starHalfOne.frame = rect;
        
        return starHalfOne
    }
    
    
    func createStarTwoImageView(contentsView: UIView) -> UIImageView {
        
        let starTwoImage:UIImage = UIImage(named: "icons8-スター-48.png")!
        starTwo = UIImageView(image: starTwoImage)
        let rect:CGRect =
        CGRect(x:206, y:446, width:34, height:34)
        starTwo.frame = rect;
        
        return starTwo
    }
    
    func createStarHalfTwoImageView(contentsView: UIView) -> UIImageView {
        
        let starHalfTwoImage:UIImage = UIImage(named: "starHalf.png")!
        starHalfTwo = UIImageView(image: starHalfTwoImage)
        let rect:CGRect =
        CGRect(x:206, y:446, width:34, height:34)
        starHalfTwo.frame = rect;
        
        return starHalfTwo
    }
    
    func createFilledStarTwoImageView(contentsView: UIView) -> UIImageView {
        
        let starTwoImage:UIImage = UIImage(named: "icons8-star-48.png")!
        starTwo = UIImageView(image: starTwoImage)
        let rect:CGRect =
        CGRect(x:206, y:446, width:34, height:34)
        starTwo.frame = rect;
        
        return starTwo
    }
    
    
    func createStarThreeImageView(contentsView: UIView) -> UIImageView {
        
        let starThreeImage:UIImage = UIImage(named: "icons8-スター-48.png")!
        starThree = UIImageView(image: starThreeImage)
        let rect:CGRect =
        CGRect(x:241, y:446, width:34, height:34)
        starThree.frame = rect;
        
        return starThree
    }
    
    func createStarHalfThreeImageView(contentsView: UIView) -> UIImageView {
        
        let starHalfThreeImage:UIImage = UIImage(named: "starHalf.png")!
        starHalfThree = UIImageView(image: starHalfThreeImage)
        let rect:CGRect =
        CGRect(x:241, y:446, width:34, height:34)
        starHalfThree.frame = rect;
        
        return starHalfThree
    }
    
    func createFilledStarThreeImageView(contentsView: UIView) -> UIImageView {
        
        let starThreeImage:UIImage = UIImage(named: "icons8-star-48.png")!
        starThree = UIImageView(image: starThreeImage)
        let rect:CGRect =
        CGRect(x:241, y:446, width:34, height:34)
        starThree.frame = rect;
        
        return starThree
    }
    
    func createStarFourImageView(contentsView: UIView) -> UIImageView {
        
        let starFourImage:UIImage = UIImage(named: "icons8-スター-48.png")!
        starFour = UIImageView(image: starFourImage)
        let rect:CGRect =
        CGRect(x:276, y:446, width:34, height:34)
        starFour.frame = rect;
        
        return starFour
    }
    
    func createStarHalfFourImageView(contentsView: UIView) -> UIImageView {
        
        let starHalfFourImage:UIImage = UIImage(named: "starHalf.png")!
        starHalfFour = UIImageView(image: starHalfFourImage)
        let rect:CGRect =
        CGRect(x:276, y:446, width:34, height:34)
        starHalfFour.frame = rect;
        
        return starHalfFour
    }
    
    func createFilledStarFourImageView(contentsView: UIView) -> UIImageView {
        
        let starFourImage:UIImage = UIImage(named: "icons8-star-48.png")!
        starFour = UIImageView(image: starFourImage)
        let rect:CGRect =
        CGRect(x:276, y:446, width:34, height:34)
        starFour.frame = rect;
        
        return starFour
    }
    
    func createStarFiveImageView(contentsView: UIView) -> UIImageView {
        
        let starFiveImage:UIImage = UIImage(named: "icons8-スター-48.png")!
        starFive = UIImageView(image: starFiveImage)
        let rect:CGRect =
        CGRect(x:309, y:446, width:34, height:34)
        starFive.frame = rect;
        
        return starFive
    }
    
    func createFilledStarFiveImageView(contentsView: UIView) -> UIImageView {
        
        let starFiveImage:UIImage = UIImage(named: "icons8-star-48.png")!
        starFive = UIImageView(image: starFiveImage)
        let rect:CGRect =
        CGRect(x:309, y:446, width:34, height:34)
        starFive.frame = rect;
        
        return starFive
    }
    
    func createStarHalfFiveImageView(contentsView: UIView) -> UIImageView {
        
        let starHalfFiveImage:UIImage = UIImage(named: "starHalf.png")!
        starHalfFive = UIImageView(image: starHalfFiveImage)
        let rect:CGRect =
        CGRect(x:309, y:446, width:34, height:34)
        starHalfFive.frame = rect;
        
        return starHalfFive
    }
    
    func createEasyCreditsLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let easyCreditsLabel = UILabel()
        easyCreditsLabel.textColor = UIColor.darkGray
        easyCreditsLabel.font = UIFont.systemFont(ofSize: 15)
        easyCreditsLabel.frame = CGRect(x: ((self.view.bounds.width-390)/2), y: 671, width: 390, height: 18)
        easyCreditsLabel.textAlignment = NSTextAlignment.center
        easyCreditsLabel.backgroundColor = #colorLiteral(red: 0.8862306476, green: 0.790310204, blue: 1, alpha: 1)
        easyCreditsLabel.text = "楽単レベル"
        
        return easyCreditsLabel
    }
    
    func createLectureDifficultyLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let lectureDifficultyLabel = UILabel()
        lectureDifficultyLabel.textColor = UIColor.darkGray
        lectureDifficultyLabel.font = UIFont.systemFont(ofSize: 12)
        lectureDifficultyLabel.frame = CGRect(x: ((self.view.bounds.width-340)/2), y: 702, width: 92, height: 20)
        lectureDifficultyLabel.textAlignment = NSTextAlignment.center
        lectureDifficultyLabel.text = "講義の難易度"
        
        return lectureDifficultyLabel
    }
    
    func createAssignmentsDifficultyLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let assignmentsDifficultyLabel = UILabel()
        assignmentsDifficultyLabel.textColor = UIColor.darkGray
        assignmentsDifficultyLabel.font = UIFont.systemFont(ofSize: 12)
        assignmentsDifficultyLabel.frame = CGRect(x: ((self.view.bounds.width-90)/2), y: 702, width: 92, height: 20)
        assignmentsDifficultyLabel.textAlignment = NSTextAlignment.center
        assignmentsDifficultyLabel.text = "課題の難易度"
        
        return assignmentsDifficultyLabel
    }
    
    func createExamsDifficultyLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let examsDifficultyLabel = UILabel()
        examsDifficultyLabel.textColor = UIColor.darkGray
        examsDifficultyLabel.font = UIFont.systemFont(ofSize: 12)
        examsDifficultyLabel.frame = CGRect(x: ((self.view.bounds.width+160)/2), y: 702, width: 89, height: 20)
        examsDifficultyLabel.textAlignment = NSTextAlignment.center
        examsDifficultyLabel.text = "テストの難易度"
        
        return examsDifficultyLabel
    }
    
    func createLectureLevelLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        lectureLevelLabel = UILabel()
        lectureLevelLabel.textColor = UIColor.darkGray
        lectureLevelLabel.font = UIFont.systemFont(ofSize: 12)
        lectureLevelLabel.frame = CGRect(x: ((self.view.bounds.width-343)/2), y: 734, width: 92, height: 16)
        lectureLevelLabel.textAlignment = NSTextAlignment.center
        //        lectureLevelLabel.text = "loading"
        
        return lectureLevelLabel
    }
    
    func createAssignmentsLevelLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        assignmentsLevelLabel = UILabel()
        assignmentsLevelLabel.textColor = UIColor.darkGray
        assignmentsLevelLabel.font = UIFont.systemFont(ofSize: 12)
        assignmentsLevelLabel.frame = CGRect(x: ((self.view.bounds.width-105)/2), y: 734, width: 103, height: 16)
        assignmentsLevelLabel.textAlignment = NSTextAlignment.center
        //        assignmentsLevelLabel.text = "loading"
        
        return assignmentsLevelLabel
    }
    
    func createExamsLevelLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        examsLevelLabel = UILabel()
        examsLevelLabel.textColor = UIColor.darkGray
        examsLevelLabel.font = UIFont.systemFont(ofSize: 12)
        examsLevelLabel.frame = CGRect(x: ((self.view.bounds.width+157)/2), y: 734, width: 89, height: 16)
        examsLevelLabel.textAlignment = NSTextAlignment.center
        //        examsLevelLabel.text = "loading"
        
        return examsLevelLabel
    }
    
    func createHowMuchEasyCreditsLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let howMuchEasyCreditsLabel = UILabel()
        howMuchEasyCreditsLabel.textColor = UIColor.darkGray
        howMuchEasyCreditsLabel.font = UIFont.systemFont(ofSize: 15)
        howMuchEasyCreditsLabel.frame = CGRect(x: ((self.view.bounds.width-390)/2), y: 800, width: 390, height: 18)
        howMuchEasyCreditsLabel.textAlignment = NSTextAlignment.center
        howMuchEasyCreditsLabel.backgroundColor = #colorLiteral(red: 0.8862306476, green: 0.790310204, blue: 1, alpha: 1)
        howMuchEasyCreditsLabel.text = " 単位の取りやすさ"
        
        return howMuchEasyCreditsLabel
    }
    
    
    func createStarOneAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "star")
        animationView.frame = CGRect(x: 10, y: 807, width: 140, height: 140)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    func createEmptyStarTwoAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "emptyStarAnimation")
        animationView.frame = CGRect(x: 10, y: 807, width: 140, height: 140)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    func createStarTwoAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "star")
        animationView.frame = CGRect(x: 69, y: 807, width: 140, height: 140)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    
    func createStarThreeAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "star")
        animationView.frame = CGRect(x: 129, y: 807, width: 140, height: 140)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    func createEmptyStarThreeAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "emptyStarAnimation")
        animationView.frame = CGRect(x: 129, y: 807, width: 140, height: 140)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    func createStarFourAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "star")
        animationView.frame = CGRect(x: 189, y: 807, width: 140, height: 140)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    func createEmptyStarFourAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "emptyStarAnimation")
        animationView.frame = CGRect(x: 189, y: 807, width: 140, height: 140)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    func createStarFiveAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "star")
        animationView.frame = CGRect(x: 249, y: 807, width: 140, height: 140)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    func createEmptyStarFiveAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "emptyStarAnimation")
        animationView.frame = CGRect(x: 249, y: 807, width: 140, height: 140)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    func createPersonaAnimationView(contentsView: UIView) -> AnimationView {
        let animationView = AnimationView(name: "opinionPeople")
        animationView.frame = CGRect(x: 20, y: 979, width: 100, height: 100)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }
    
    func createBalloonImageView(contentsView: UIView) -> UIImageView {
        
        let balloonImage:UIImage = UIImage(named: "balloon.png")!
        let balloonImageView = UIImageView(image: balloonImage)
        let rect:CGRect =
        CGRect(x:((self.view.bounds.width-170)/2), y:1029, width:259, height:128)
        balloonImageView.frame = rect;
        
        return balloonImageView
    }
    
    func createOpinionTextView(contentsView: UIView) -> UITextView {
        opinionTextView = UITextView()
        opinionTextView.textColor = UIColor.darkGray
        opinionTextView.backgroundColor = UIColor.clear
        opinionTextView.font = UIFont.systemFont(ofSize: 12)
        opinionTextView.frame = CGRect(x:((self.view.bounds.width-115)/2), y: 1050, width: 221, height: 96)
        opinionTextView.isEditable = false
        //        opinionTextView.text = "いわゆる楽単です。ゼミのメンバーやその時の興味によって内容が変わります。自由度の高いゼミです。"
        
        return opinionTextView
    }
    
    func createOpinionLabel(contentsView: UIView) -> UILabel {
        // labelを作る
        let opinionLabel = UILabel()
        opinionLabel.textColor = UIColor.darkGray
        opinionLabel.font = UIFont.systemFont(ofSize: 15)
        opinionLabel.frame = CGRect(x: ((self.view.bounds.width-390)/2), y: 950, width: 390, height: 18)
        opinionLabel.textAlignment = NSTextAlignment.center
        opinionLabel.backgroundColor = #colorLiteral(red: 0.8862306476, green: 0.790310204, blue: 1, alpha: 1)
        opinionLabel.text = "受講者たちの意見"
        
        return opinionLabel
    }
    
    func createLineOne(contentsView: UIView) -> UIView {
        let lineOneView = UIView()
        lineOneView.backgroundColor = .systemGray
        let rect:CGRect =
        CGRect(x:((self.view.bounds.width-134)/2), y:589, width:1.0, height:70)
        lineOneView.frame = rect;
        
        return lineOneView
    }
    
    func createLineTwo(contentsView: UIView) -> UIView {
        let lineTwoView = UIView()
        lineTwoView.backgroundColor = .systemGray
        let rect:CGRect =
        CGRect(x:((self.view.bounds.width+128)/2), y:589, width:1.0, height:70)
        lineTwoView.frame = rect;
        
        return lineTwoView
    }
    
    func createLineThree(contentsView: UIView) -> UIView {
        let lineThreeView = UIView()
        lineThreeView.backgroundColor = .systemGray
        let rect:CGRect =
        CGRect(x:((self.view.bounds.width-134)/2), y:702, width:1.0, height:70)
        lineThreeView.frame = rect;
        
        return lineThreeView
    }
    
    func createLineFour(contentsView: UIView) -> UIView {
        let lineFourView = UIView()
        lineFourView.backgroundColor = .systemGray
        let rect:CGRect =
        CGRect(x:((self.view.bounds.width+128)/2), y:702, width:1.0, height:70)
        lineFourView.frame = rect;
        
        return lineFourView
    }
    
    
    

    
    
    
    func createContentsView() -> UIView {
        
        
        // contentsViewを作る
        let contentsView = UIView()
        contentsView.frame = CGRect(x: 0, y: 0, width: 340, height: 1200)
        // contentsViewにlabelを配置させる
        let lineThreeView = createLineThree(contentsView: contentsView)
        let lineFourView = createLineFour(contentsView: contentsView)
        let lineTwoView = createLineTwo(contentsView: contentsView)
        let lineOneView = createLineOne(contentsView: contentsView)
        let opinionLabel = createOpinionLabel(contentsView: contentsView)
        let opinionTextView = createOpinionTextView(contentsView: contentsView)
        let balloonImageView = createBalloonImageView(contentsView: contentsView)
        let personaAnimationView = createPersonaAnimationView(contentsView: contentsView)
        let starOneAnimationView = createStarOneAnimationView(contentsView: contentsView)
        let starTwoAnimationView = createStarTwoAnimationView(contentsView: contentsView)
        let starThreeAnimationView = createStarThreeAnimationView(contentsView: contentsView)
        let starFourAnimationView = createStarFourAnimationView(contentsView: contentsView)
        let starFiveAnimationView = createStarFiveAnimationView(contentsView: contentsView)
        let lectureLevelLabel = createLectureLevelLabel(contentsView: contentsView)
        let assignmentsLevelLabel = createAssignmentsLevelLabel(contentsView: contentsView)
        let examsLevelLabel = createExamsLevelLabel(contentsView: contentsView)
        let examsDifficultyLabel = createExamsDifficultyLabel(contentsView: contentsView)
        let assignmentsDifficultyLabel = createAssignmentsDifficultyLabel(contentsView: contentsView)
        let lectureDifficultyLabel = createLectureDifficultyLabel(contentsView: contentsView)
        let nameLabel = createLabelSubjectName(contentsView: contentsView)
        let timeLabel = createLabelSubjectTime(contentsView: contentsView)
        let profLabel = createLabelSubjectProf(contentsView: contentsView)
        let placeLabel = createLabelSubjectPlace(contentsView: contentsView)
        let creditLabel = createLabelSubjectCredits(contentsView: contentsView)
        let comprehensiveEvaluationLabel = createComprehensiveEvalutionLabel(contentsView: contentsView)
        let scoringMethodLabel = createScoringMethodLabel(contentsView: contentsView)
        let severalMethodScoringLabel = createSeveralMethodsScoringLabel(contentsView: contentsView)
        let frequencyLabel = createFrequencyLabel(contentsView: contentsView)
        let attendantsConfirmLabel = createAttendantsConfirmLabel(contentsView: contentsView)
        let assignmentsLabel = createAssignmentsLabel(contentsView: contentsView)
        let testLabel = createTestLabel(contentsView: contentsView)
        let attendantsCheckFrequencyLabel = createAttendantsCheckFrequencyLabel(contentsView: contentsView)
        let assignmentsCheckFrequencyLabel = createAssignmentsCheckFrequencyLabel(contentsView: contentsView)
        let examFrequencyLabel = createExamFrequencyLabel(contentsView: contentsView)
        let timeImageView = createTimeImageView(contentsView: contentsView)
        let profImageView = createProfImageView(contentsView: contentsView)
        let placeImageView = createPlaceImageView(contentsView: contentsView)
        let creditsImageView = createCreditsImageView(contentsView: contentsView)
        let starOneImageView = createStarOneImageView(contentsView: contentsView)
        let starTwoImageView = createStarTwoImageView(contentsView: contentsView)
        let starThreeImageView = createStarThreeImageView(contentsView: contentsView)
        let starFourImageView = createStarFourImageView(contentsView: contentsView)
        let starFiveImageView = createStarFiveImageView(contentsView: contentsView)
        let filledStarOneImageView = createFilledStarOneImageView(contentsView: contentsView)
        let filledStarTwoImageView = createFilledStarTwoImageView(contentsView: contentsView)
        let filledStarThreeImageView = createFilledStarThreeImageView(contentsView: contentsView)
        let filledStarFourImageView = createFilledStarFourImageView(contentsView: contentsView)
        let filledStarFiveImageView = createFilledStarFiveImageView(contentsView: contentsView)
        let easyCreditsLabel = createEasyCreditsLabel(contentsView: contentsView)
        let starHalfOne = createHalfStarOneImageView(contentsView: contentsView)
        let starHalfTwo = createStarHalfTwoImageView(contentsView: contentsView)
        let starHalfThree = createStarHalfThreeImageView(contentsView: contentsView)
        let starHalfFour = createStarHalfFourImageView(contentsView: contentsView)
        let starHalfFive = createStarHalfFiveImageView(contentsView: contentsView)
        let howMuchEasyCreditsLabel = createHowMuchEasyCreditsLabel(contentsView: contentsView)
        
        
        if self.receiveSubjectFromDetail != nil{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                if self.recieveStarFromDetail == "0"{
                    contentsView.addSubview(starOneImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                    contentsView.addSubview(starTwoImageView)
                } else if self.recieveStarFromDetail == "1"{
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                    contentsView.addSubview(starTwoImageView)
                } else if self.recieveStarFromDetail == "2"{
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                } else if self.recieveStarFromDetail == "3"{
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                } else if self.recieveStarFromDetail == "4"{
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(filledStarFourImageView)
                } else if self.recieveStarFromDetail == "5"{
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(filledStarFourImageView)
                    contentsView.addSubview(filledStarFiveImageView)
                    
                } else if self.recieveStarFromDetail == "0.5"{
                    contentsView.addSubview(starHalfOne)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                    contentsView.addSubview(starTwoImageView)
                    
                } else if self.recieveStarFromDetail == "1.5"{
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(starHalfTwo)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                } else if self.recieveStarFromDetail == "2.5"{
                    contentsView.addSubview(starHalfThree)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                } else if self.recieveStarFromDetail == "3.5"{
                    contentsView.addSubview(starHalfFour)
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(starFiveImageView)
                } else if self.recieveStarFromDetail == "4.5"{
                    contentsView.addSubview(starHalfFive)
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(filledStarFourImageView)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.receiveStarFromSubject == "0"{
                    contentsView.addSubview(starOneImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                    contentsView.addSubview(starTwoImageView)
                } else if self.receiveStarFromSubject == "1"{
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                    contentsView.addSubview(starTwoImageView)
                } else if self.receiveStarFromSubject == "2"{
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                } else if self.receiveStarFromSubject == "3"{
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                } else if self.receiveStarFromSubject == "4"{
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(filledStarFourImageView)
                } else if self.receiveStarFromSubject == "5"{
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(filledStarFourImageView)
                    contentsView.addSubview(filledStarFiveImageView)
                } else if self.receiveStarFromSubject == "0.5"{
                    contentsView.addSubview(starHalfOne)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                    contentsView.addSubview(starTwoImageView)
                    
                } else if self.receiveStarFromSubject == "1.5"{
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(starHalfTwo)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                    contentsView.addSubview(starThreeImageView)
                } else if self.receiveStarFromSubject == "2.5"{
                    contentsView.addSubview(starHalfThree)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(starFiveImageView)
                    contentsView.addSubview(starFourImageView)
                } else if self.receiveStarFromSubject == "3.5"{
                    contentsView.addSubview(starHalfFour)
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(starFiveImageView)
                } else if self.receiveStarFromSubject == "4.5"{
                    contentsView.addSubview(starHalfFive)
                    contentsView.addSubview(filledStarThreeImageView)
                    contentsView.addSubview(filledStarOneImageView)
                    contentsView.addSubview(filledStarTwoImageView)
                    contentsView.addSubview(filledStarFourImageView)
                }
            }
        }
        
        contentsView.addSubview(lineOneView)
        contentsView.addSubview(opinionLabel)
        contentsView.addSubview(examsDifficultyLabel)
        contentsView.addSubview(assignmentsDifficultyLabel)
        contentsView.addSubview(creditsImageView)
        contentsView.addSubview(placeImageView)
        contentsView.addSubview(profImageView)
        contentsView.addSubview(timeImageView)
        contentsView.addSubview(examFrequencyLabel)
        contentsView.addSubview(assignmentsCheckFrequencyLabel)
        contentsView.addSubview(attendantsCheckFrequencyLabel)
        contentsView.addSubview(testLabel)
        contentsView.addSubview(assignmentsLabel)
        contentsView.addSubview(attendantsConfirmLabel)
        contentsView.addSubview(frequencyLabel)
        contentsView.addSubview(severalMethodScoringLabel)
        contentsView.addSubview(scoringMethodLabel)
        contentsView.addSubview(creditLabel)
        contentsView.addSubview(placeLabel)
        contentsView.addSubview(nameLabel)
        contentsView.addSubview(timeLabel)
        contentsView.addSubview(profLabel)
        contentsView.addSubview(comprehensiveEvaluationLabel)
        contentsView.addSubview(easyCreditsLabel)
        contentsView.addSubview(lectureDifficultyLabel)
        contentsView.addSubview(lectureLevelLabel)
        contentsView.addSubview(assignmentsLevelLabel)
        contentsView.addSubview(examsLevelLabel)
        contentsView.addSubview(howMuchEasyCreditsLabel)
        contentsView.addSubview(lineTwoView)
        contentsView.addSubview(lineThreeView)
        contentsView.addSubview(lineFourView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.receiveCreditDifficultyNumFromDetail != nil{
                if self.receiveCreditDifficultyNumFromDetail == "0"{
                    print("no result")
                } else if self.receiveCreditDifficultyNumFromDetail == "1"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()

                } else if self.receiveCreditDifficultyNumFromDetail == "2"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()
                    contentsView.addSubview(starTwoAnimationView)
                    starTwoAnimationView.play()

                } else if self.receiveCreditDifficultyNumFromDetail == "3"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()
                    contentsView.addSubview(starTwoAnimationView)
                    starTwoAnimationView.play()
                    contentsView.addSubview(starThreeAnimationView)
                    starThreeAnimationView.play()

                } else if self.receiveCreditDifficultyNumFromDetail == "4"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()
                    contentsView.addSubview(starTwoAnimationView)
                    starTwoAnimationView.play()
                    contentsView.addSubview(starThreeAnimationView)
                    starThreeAnimationView.play()
                    contentsView.addSubview(starFourAnimationView)
                    starFourAnimationView.play()

                } else if self.receiveCreditDifficultyNumFromDetail == "5"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()
                    contentsView.addSubview(starTwoAnimationView)
                    starTwoAnimationView.play()
                    contentsView.addSubview(starThreeAnimationView)
                    starThreeAnimationView.play()
                    contentsView.addSubview(starFourAnimationView)
                    starFourAnimationView.play()
                    contentsView.addSubview(starFiveAnimationView)
                    starFiveAnimationView.play()
                }
            } else {
                
                if self.receiveCreditDifficultyNumFromSubject == "0"{
                    print("no result")
                } else if self.receiveCreditDifficultyNumFromSubject == "1"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()

                } else if self.receiveCreditDifficultyNumFromSubject == "2"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()
                    contentsView.addSubview(starTwoAnimationView)
                    starTwoAnimationView.play()

                } else if self.receiveCreditDifficultyNumFromSubject == "3"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()
                    contentsView.addSubview(starTwoAnimationView)
                    starTwoAnimationView.play()
                    contentsView.addSubview(starThreeAnimationView)
                    starThreeAnimationView.play()

                } else if self.receiveCreditDifficultyNumFromSubject == "4"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()
                    contentsView.addSubview(starTwoAnimationView)
                    starTwoAnimationView.play()
                    contentsView.addSubview(starThreeAnimationView)
                    starThreeAnimationView.play()
                    contentsView.addSubview(starFourAnimationView)
                    starFourAnimationView.play()

                } else if self.receiveCreditDifficultyNumFromSubject == "5"{
                    contentsView.addSubview(starOneAnimationView)
                    starOneAnimationView.play()
                    contentsView.addSubview(starTwoAnimationView)
                    starTwoAnimationView.play()
                    contentsView.addSubview(starThreeAnimationView)
                    starThreeAnimationView.play()
                    contentsView.addSubview(starFourAnimationView)
                    starFourAnimationView.play()
                    contentsView.addSubview(starFiveAnimationView)
                    starFiveAnimationView.play()
                }
            }
        }

        contentsView.addSubview(personaAnimationView)
        personaAnimationView.play()
        contentsView.addSubview(balloonImageView)
        contentsView.addSubview(opinionTextView)

        return contentsView
    }
    
    func configureSV() {
        
        // scrollViewにcontentsViewを配置させる
        let subView = createContentsView()
        scrollView.addSubview(subView)
        
        // scrollViewにcontentsViewのサイズを教える
        scrollView.contentSize = subView.frame.size
        
    }
    
    
    
    
    func makeRandomNumber(){
        randomNumber = Int.random(in: 0...2)
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
    
    func startAnimation(){
        if randomNumber == 0{
            view.addSubview(animationView)
            animationView.play()
        } else {
            print("not this")
        }
    }
    
    func startAnimation2(){
        if randomNumber == 1{
            view.addSubview(animationView2)
            animationView2.play()
        } else {
            print("not two")
        }
    }
    func startAnimation3(){
        if randomNumber == 2 {
            view.addSubview(animationView3)
            animationView3.play()
        } else {
            print("not three")
        }
    }
}


