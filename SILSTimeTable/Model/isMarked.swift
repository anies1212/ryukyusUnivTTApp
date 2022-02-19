//
//  User.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/10.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB

// ToDoリストでチェックがあるかどうかのクラス
class isMarked: NSObject{
    
    var done: Bool = false

    init(done:Bool) {
        self.done = done
    }

}
