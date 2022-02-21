//
//  Class.swift
//  SILSTimeTable
//
//  Created by Taiga Hashimoto on 2021/06/07.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

// NCMBにある授業情報をXcode上でやり取りするときに1セットにしておくためのクラス
class Class{
    
    var objectId: String!
    var subjectName: String!
    var classPlace: String!
    var Prof: String!
    var dayTime: String!
    var creditNum: String!
    var star: String!
    var assignmentsCheckFrequency: String!
    var assignmentsLevel: String!
    var attendantsCheckFrequency: String!
    var creditDifficultyStarNum: String!
    var examFrequency: String!
    var examsLevel: String!
    var lectureLevel: String!
    var scoringMethod: String!
    var opinion: String!
    
    init(objectId: String, subjectName: String, classPlace: String, Prof: String, dayTime: String, creditNum: String, star: String, assignmentsCheckFrequency: String, assignmentsLevel:String, attendantsCheckFrequency: String, creditDifficultyStarNum:String, examFrequency:String, examsLevel:String, lectureLevel: String, scoringMethod: String, opinion: String) {
        self.objectId = objectId
        self.subjectName = subjectName
        self.classPlace = classPlace
        self.Prof = Prof
        self.dayTime = dayTime
        self.creditNum = creditNum
        self.star = star
        self.assignmentsCheckFrequency = assignmentsCheckFrequency
        self.assignmentsLevel = assignmentsLevel
        self.attendantsCheckFrequency = attendantsCheckFrequency
        self.creditDifficultyStarNum = creditDifficultyStarNum
        self.examFrequency = examFrequency
        self.examsLevel = examsLevel
        self.lectureLevel = lectureLevel
        self.scoringMethod = scoringMethod
        self.opinion = opinion
    }
}
