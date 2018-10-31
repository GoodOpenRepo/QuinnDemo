import UIKit

extension CustomProjectCombinationView{
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
                print("-----keybard--------::",keyboardH)
                inputContainerViewBottom.constant = keyboardH
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification){
        afterKeyboardHidden()
//        DispatchQueue.main.async {[weak self] in
//            self?.delegate?.delegateHiddenKeyboardAnimate()
//        }
    }
}

extension CustomProjectCombinationView:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        afterKeyboardHidden()
        return true
    }
}


extension CustomProjectCombinationView{
    func showTimeClooseView(){
        let alert = UIAlertController.init(title: "选择时间格式", message: nil, preferredStyle: .actionSheet)
        
        let act1 = UIAlertAction.init(title: "2018.10.08 18:40", style: .default) { [weak self](act1) in
            print("act1")
            self?.dataModel?.currentTime?.style = 0
            self?.currentTimeLB.text =  self?.setTimeChooseStyle(0)
        }
        let act2 = UIAlertAction.init(title: "2018.10.08 星期一", style: .default) { [weak self](act2) in
            self?.dataModel?.currentTime?.style = 1
            self?.currentTimeLB.text =  self?.setTimeChooseStyle(1)
        }
        let act3 = UIAlertAction.init(title: "星期一 14:50", style: .default) { [weak self](act3) in
            self?.dataModel?.currentTime?.style = 2
            self?.currentTimeLB.text =  self?.setTimeChooseStyle(2)
        }
        let act4 = UIAlertAction.init(title: "2018.10.08", style: .default) { [weak self](act4) in
            self?.dataModel?.currentTime?.style = 3
            self?.currentTimeLB.text =  self?.setTimeChooseStyle(3)
        }
        let act5 = UIAlertAction.init(title: "星期一", style: .default) { [weak self](act5) in
            self?.dataModel?.currentTime?.style = 4
            self?.currentTimeLB.text =  self?.setTimeChooseStyle(4)
        }
        let act6 = UIAlertAction.init(title: "14:50", style: .default) { [weak self](act6) in
            self?.dataModel?.currentTime?.style = 5
            self?.currentTimeLB.text =  self?.setTimeChooseStyle(5)
        }
        let act7 = UIAlertAction.init(title: "取消", style: .cancel) { (act7) in
            print("act3")
        }
        alert.addAction(act1)
        alert.addAction(act2)
        alert.addAction(act3)
        alert.addAction(act4)
        alert.addAction(act5)
        alert.addAction(act6)
        alert.addAction(act7)
        CurrentViewController()?.present(alert, animated: true, completion: {
            
        })
    }
    func setTimeChooseStyle(_ style:Int) ->String{
        var dateFormat = ""
        switch style {
        case 0:
            dateFormat = "yyyy.MM.dd HH:mm"
        case 1:
            dateFormat = "yyyy.MM.dd EEEE"
        case 2:
            dateFormat = "EEEE HH:mm"
        case 3:
            dateFormat = "yyyy.MM.dd"
        case 4:
            dateFormat = "EEEE"
        case 5:
            dateFormat = "HH:mm"
        default:
            break
        }
        let str = getFormatterDate(Date(), dateFormat: dateFormat)
        return str
    }
    
    func getFormatterDate(_ date: Date,dateFormat:String) -> String {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        dateFormater.locale = Locale(identifier: "zh_CN")
        
        return dateFormater.string(from: date)
    }
    
    
    
}
func CurrentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
        return CurrentViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        return CurrentViewController(base: tab.selectedViewController)
    }
    if let presented = base?.presentedViewController {
        return CurrentViewController(base: presented)
    }
    return base
}
