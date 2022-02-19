//
//  FloatyFactory.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/12/02.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Floaty

final class FloatyFactory {

    // Delegateメソッドでも使うので定数化
    static let openButtonImage = UIImage(named: "plusButton96")
    static let openButtonImageAfterOpening = UIImage(named: "plusButton96")
    static let paddingX: CGFloat = 8
    static let paddingY: CGFloat = -20
    static let opendPaddingX: CGFloat = -20
    static let opendPaddingY: CGFloat = -120

    static func makeFloaty(vc: UIViewController & FloatyDelegate) -> Floaty {

        let fab = Floaty()
        // 閉じた状態のボタン画像
        fab.buttonImage = openButtonImage
        // デフォルトのボタンを見えなくするために透明を指定
        fab.buttonColor = .clear
        fab.buttonShadowColor = .clear
        // アイテムもカスタム画像を使用するのでデフォルトの色を透明化
        fab.itemButtonColor = .clear
        // カスタム画像を使用するのでサイズを指定。正円になるもよう
        fab.size = 130
        // 右側からの余白
        fab.paddingX = paddingX
        // 下側からの余白
        fab.paddingY = paddingY
        // アイテム間の余白
        fab.itemSpace = 16
        fab.hasShadow = false
        // アニメーション付けたかったが、アイテムの位置をpaddingで指定しているので、
        // アニメーションをつけると不自然になってしまう
        fab.openAnimationType = .none
        // 開いた際の背景色を指定できる
        fab.overlayColor = UIColor.clear
        // デリゲートメソッドを使うために使用するViewControllerを指定する
        fab.fabDelegate = vc
        // 閉じるボタン
        let closeItem = FloatyItem()
        // サイズを指定しないと画像は小さく表示されてしまう
        closeItem.imageSize = CGSize(width: 76, height: 76)
        closeItem.icon = UIImage(named: "fab-close")
        closeItem.title = "Close"
        // Labelを指定できるので柔軟に見た目を変えられそう
        closeItem.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        closeItem.titleLabel.textAlignment = .right
        // Floatyに定義したアイテムを追加する
        fab.addItem(item: closeItem)

        let lineItem = FloatyItem()
        lineItem.imageSize = CGSize(width: 68, height: 68)
        lineItem.title = "Inquiry via LINE"
        lineItem.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lineItem.titleLabel.textAlignment = .right
        lineItem.icon = UIImage(named: "LINE")
        lineItem.handler = { item in
            guard let url = URL(string: "LINEのURLスキームを指定") else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("no Line")
            }
        }
        fab.addItem(item: lineItem)

        return fab
    }

    // デリゲートメソッドで行いたいことも共通なのでメソッド化しておく
    static func floatyWillOpen(_ floaty: Floaty) {
        floaty.buttonImage = openButtonImageAfterOpening
        floaty.paddingX = opendPaddingX
        floaty.paddingY = opendPaddingY
    }

    static func floatyWillClose(_ floaty: Floaty) {
        floaty.buttonImage = openButtonImage
        floaty.paddingX = paddingX
        floaty.paddingY = paddingY
    }
}
