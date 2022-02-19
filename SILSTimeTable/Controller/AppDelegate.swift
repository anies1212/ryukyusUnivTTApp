//
//  AppDelegate.swift
//  SILSTimeTable
//
//  Created by Apple on 2021/05/31.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import GoogleMobileAds // 追加
import Siren
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // NCMBのセットアップ
        let applicationKey = "c257fc3392bcc3b9820c015803727bb4a6b9d24e4ffd311ef5de7de4844255b6"
        let ClientKey = "f81b273b03990999126ead32cad4189e0b87b705281ac3df05a82544754318ae"
        
        NCMB.setApplicationKey(applicationKey, clientKey: ClientKey)
        // sirenの強制アップデート設定用関数
        forceUpdate()
        // Google Mobile Ads SDKの初期化
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
// 以下、追記
private extension AppDelegate {

    func forceUpdate() {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(forceLanguageLocalization: .japanese)
        siren.rulesManager = RulesManager(
            majorUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force), // A.b.c.d
            minorUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force), // a.B.c.d
            patchUpdateRules: Rules(promptFrequency: .daily, forAlertType: .option), // a.b.C.d
            revisionUpdateRules: Rules(promptFrequency: .weekly, forAlertType: .skip) // a.b.c.D
        )
        Siren.shared.apiManager = APIManager(country: .japan)
        siren.wail()
    }
}

