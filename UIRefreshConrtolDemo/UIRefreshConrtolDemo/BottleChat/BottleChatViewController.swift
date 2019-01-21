//
//  BottleChatViewController.swift
//  UIRefreshConrtolDemo
//
//  Created by Quinn on 2019/1/7.
//  Copyright © 2019 Quinn. All rights reserved.
//
import UIKit

class BottleChatViewController: UIViewController {
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var sex: UIImageView!
    var bottleInfo:NewBottleInfo!
    var messageList:[NewBottleMessage]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.separatorStyle = .none
        textFiled.delegate = self
        scrollToEnd()
        requestBottleChat(id: bottleInfo.bottle_id) { [weak self](list) in
            self?.messageList = list
            self?.tableView.reloadData()
        }
        
        titleLB.text = "来自" + bottleInfo.addr
        switch bottleInfo.sex {
        case 0:
            sex.image = UIImage(named: "bottle_gender_male")
        case 1:
            sex.image = UIImage(named: "bottle_gender_female")
        case 2:
            sex.image = nil
        default:
            break
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addKeyboardNotification()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotification()
    }

    
    
    func scrollToEnd(animation:Bool = false){
        
        let time = DispatchTime.init(uptimeNanoseconds: NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            guard let list = self.messageList else{
                return
            }
            self.tableView.scrollToRow(at: IndexPath.init(row: list.count - 1, section: 0), at: .bottom, animated: animation)
        }

    }


    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension BottleChatViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFiled.text?.count ?? 0 > 0{
//            textFiled.resignFirstResponder()
            let newMessage = NewBottleMessage()
            newMessage.source = 0
            newMessage.content = textField.text!
            messageList?.append(newMessage)
            let moveHeight = self.tableView.contentSize.height - self.tableView.frame.height - 8
            if  moveHeight > 0{
                tableView.insertRows(at: [IndexPath(row: (messageList?.count ?? 0) - 1, section: 0)], with: .none)
                tableView.reloadRows(at: [IndexPath(row: (self.messageList?.count ?? 0) - 1, section: 0)], with: .automatic)
            }else{
                tableView.reloadData()

            }

            scrollToEnd(animation:true)

//            UIView.animate(withDuration: 0.2, animations: {
//                self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.height)
//            })
            
            textFiled.text = nil
            return true
        }
        return false
    }
    func addKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification:Notification){
        print(#function)
        if let dic : NSDictionary = notification.userInfo as NSDictionary?{
            let info : AnyObject? = dic.object(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject
            
            if let info1 = info{
                let keyboardH = info1.cgRectValue.size.height
                inputViewBottom.constant = keyboardH
                print(self.tableView.contentOffset.y)
                print(self.tableView.contentSize.height)
                print(self.tableView.frame.height - 8)
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    let moveHeight = self.tableView.contentSize.height - self.tableView.frame.height - 8
                    if  moveHeight > 0{
                         self.tableView.contentOffset = CGPoint(x: 0, y: moveHeight)
                    }
                },completion:{(_) in
                     self.scrollToEnd(animation:true)
                })
                
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification){
        inputViewBottom.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension BottleChatViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textFiled.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bottleMsg = messageList![indexPath.row]
        return chooseMessageTableCell(indexPath: indexPath, model: bottleMsg)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList?.count ?? 0
    }
    
    func chooseMessageTableCell(indexPath:IndexPath,model:NewBottleMessage)->UITableViewCell{
        var cell : UITableViewCell?
        switch indexPath.row {
        case 0:
            
            if bottleInfo.src_regid != regid{
                //1 收瓶方
                cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewLeftImgCell", for: indexPath) as! ChatTableViewLeftImgCell
                (cell as!ChatTableViewLeftImgCell).img.image =  UIImage.init(named: "4")
            }else{
                //0 发瓶方
                cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewRightImgCell", for: indexPath) as! ChatTableViewRightImgCell
                (cell as!ChatTableViewRightImgCell).img.image =  UIImage.init(named: "4")

            }
            
        case 1:
            
            if bottleInfo.src_regid == regid{
                //  0 发瓶方
                if bottleInfo.reply_icon == -1{
                    // 回复的是文本
                    cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewRightMsgCell", for: indexPath) as! ChatTableViewRightMsgCell
                    (cell as!ChatTableViewRightMsgCell).content.text = bottleInfo.first_txt

                }else{
                    // 回复的是icon
                    cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewRightIconCell", for: indexPath) as! ChatTableViewRightIconCell
                    var icon = "👍"
                    switch bottleInfo.reply_icon{
                    case 0:
                        icon = "👍"
                    case 1:
                        icon = "😍"
                    case 2:
                        icon = "😭"
                    case 3:
                        icon = "😡"
                    default:
                        break
                    }
                    (cell as!ChatTableViewRightIconCell).content.text = icon
                }
            }else{
                //1 收瓶方
                if bottleInfo.reply_icon == -1{
                    // 回复的是文本
                    cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewLeftMsgCell", for: indexPath) as! ChatTableViewLeftMsgCell
                    (cell as!ChatTableViewLeftMsgCell).content.text = bottleInfo.first_txt

                }else{
                    // 回复的是icon
                    cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewLeftIconCell", for: indexPath) as! ChatTableViewLeftIconCell
                    var icon = "👍"
                    switch bottleInfo.reply_icon{
                    case 0:
                        icon = "👍"
                    case 1:
                        icon = "😍"
                    case 2:
                        icon = "😭"
                    case 3:
                        icon = "😡"
                    default:
                        break
                    }
                    (cell as!ChatTableViewLeftIconCell).content.text = icon
                }
            }
            
        default:
            
            if model.source == 0{
                //0 发瓶方
                cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewRightMsgCell", for: indexPath) as! ChatTableViewRightMsgCell
                (cell as!ChatTableViewRightMsgCell).content.text = model.content
            }else{
                // 1 收瓶方
                cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewLeftMsgCell", for: indexPath) as! ChatTableViewLeftMsgCell
                (cell as!ChatTableViewLeftMsgCell).content.text = model.content
            }
        }
        return cell!
    }
    
    func requestBottleChat(id:Int,completed:@escaping([NewBottleMessage]?)->()) {
        var list:[NewBottleMessage] = [NewBottleMessage]()
        for i in (0...1){
            let newMessage = NewBottleMessage()
            newMessage.source = i%2
            newMessage.content = "这是第\(i)条消息"
            list.append(newMessage)
        }
        completed(list)
    }
}


