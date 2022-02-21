//
//  DetailTaskViewController.swift
//  SILSTimeTable
//
//  Created by anies1212 on 2021/09/19.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import NCMB
import PKHUD
import SkyFloatingLabelTextField
import Lottie

class DetailTaskViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var taskTitleTextField: SkyFloatingLabelTextField!
    @IBOutlet var deadlineswitch: UISwitch!
    @IBOutlet var deadlineDatePicker: UIDatePicker!
    @IBOutlet var taskDetailTextView: UITextView!
    @IBOutlet var inputSubjectTextField: SkyFloatingLabelTextField!
    var placeholder = "メモを編集"
    var selectedTask: NCMBObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        
        taskDetailTextView.backgroundColor = .white
        taskDetailTextView.text = placeholder
        taskDetailTextView.textColor = .lightGray
        showAnimation()
        taskTitleTextField.delegate = self
        inputSubjectTextField.delegate = self
        
        taskTitleTextField.delegate = self
        taskTitleTextField.text = selectedTask.object(forKey: "taskTitle") as? String
        if selectedTask.object(forKey: "deadline") as! Bool == false {
            deadlineswitch.isOn = false
            deadlineDatePicker.isEnabled = false
        } else {
            deadlineswitch.isOn = true
            deadlineDatePicker.date = selectedTask.object(forKey: "deadlineDate") as! Date
        }
        taskDetailTextView.text = selectedTask.object(forKey: "detail") as? String
        inputSubjectTextField.text = selectedTask.object(forKey: "InputtedSubject") as? String
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.taskDetailTextView.isFirstResponder) {
            self.taskDetailTextView.resignFirstResponder()
        }
    }
    
    // MARK: deadline switch
    @IBAction func deadlineSwitch(_ sender: UISwitch) {
        if sender.isOn == false {
            deadlineDatePicker.isEnabled = false
        } else {
            deadlineDatePicker.isEnabled = true
        }
    }
    
    // MARK: Back Button
    @objc func backButton() {
        let alertController = UIAlertController(title: "編集内容を破棄してよろしいですか？", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func save() {
        if taskTitleTextField.text?.isEmpty == false {
            selectedTask.setObject(taskTitleTextField.text, forKey: "taskTitle")
            if inputSubjectTextField.text?.isEmpty == false {
            selectedTask.setObject(inputSubjectTextField.text, forKey: "InputtedSubject")
            } else {
                selectedTask.setObject("-", forKey: "InputtedSubject")
            }
            if deadlineswitch.isOn == false {
                selectedTask.setObject(nil, forKey: "deadlineDate")
                selectedTask.setObject(nil, forKey: "deadlineDateString")
                selectedTask.setObject(false, forKey: "deadline")
            } else {
                selectedTask.setObject(deadlineDatePicker.date, forKey: "deadlineDate")
                selectedTask.setObject(getDate(deadlineDatePicker.date), forKey: "deadlineDateString")
                selectedTask.setObject(true, forKey: "deadline")
            }
            selectedTask.setObject(taskDetailTextView.text, forKey: "detail")
            selectedTask.setObject(false, forKey: "state")
            //他の保存
            selectedTask.saveInBackground({ (error) in
                if error != nil {
                    HUD.show(.error)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            let alertController = UIAlertController(title: "タイトルを入力してください", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (backAction) in
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: 削除
    @IBAction func trash() {
        let alertController = UIAlertController(title: "削除", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.selectedTask.deleteInBackground { (error) in
                if error != nil {
                    HUD.show(.error)
                    return
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: メソッド
    func getDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    private func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "メモを入力"
            textView.textColor = UIColor.lightGray
            placeholder = ""
        } else {
            placeholder = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholder = textView.text
    }
    
    func showAnimation() {
        let animationView = AnimationView(name: "bookStudy")
//        animationView.frame = CGRect(x: 0, y: 490, width: view.bounds.width/1.5, height: view.bounds.height/1.5) view.bounds.height/1.005
        animationView.frame = CGRect(x: view.frame.width/5.35, y: view.frame.height/1.7, width: view.bounds.width/1.75, height: 300)
//        animationView.frame = view.bounds
//           animationView.center = self.view.center
           animationView.loopMode = .loop
           animationView.contentMode = .scaleAspectFit
           animationView.animationSpeed = 1

           view.addSubview(animationView)

           animationView.play()
       }
    
    
    


}
