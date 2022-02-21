//
//  User.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/06/10.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

// ユーザーのクラス
class User: NSObject {
    
        var objectId: String
        var userName: String

        init(objectId: String, userName: String) {
            self.objectId = objectId
            self.userName = userName
        }
    }

