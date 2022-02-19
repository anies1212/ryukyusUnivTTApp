//
//  User.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/10.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB

// ToDoリストの内容のクラス
class Item: NSObject{
    var title: String
    var done: Bool = false

    init(title:String) {
        self.title = title
    }

}
