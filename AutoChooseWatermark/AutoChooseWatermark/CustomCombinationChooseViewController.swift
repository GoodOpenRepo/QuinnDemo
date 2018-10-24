//
//  CustomCombinationChooseViewController.swift
//  AutoChooseWatermark
//
//  Created by Quinn on 2018/10/24.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
protocol CustomCombinationChooseViewControllerDelegate:class {
    func CustomCombinationChooseViewControllerDelegateClickCancle()
    func CustomCombinationChooseViewControllerDelegateClickSure(sticker:UIView?)
}
class CustomCombinationChooseViewController: NSObject {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var scrollViewContentHeight: NSLayoutConstraint!
    @IBOutlet var view: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var placeHolderLB: UILabel!
    
    //时间
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var timeLB: UILabel!
    ///地点
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var locationLB: UILabel!
    ///经纬度
    @IBOutlet weak var lonlatSwitch: UISwitch!
    @IBOutlet weak var lonlatLB: UILabel!
    ///海拔
    @IBOutlet weak var altitudeSwitch: UISwitch!
    @IBOutlet weak var altitudeLB: UILabel!
    //天气
    @IBOutlet weak var weatherSwitch: UISwitch!
    @IBOutlet weak var weatherLB: UILabel!
    
    weak var delegate:CustomCombinationChooseViewControllerDelegate?
    var dataModel :CustomCombinationModel?
    var sticker:UIView?
    var isEditVc:Bool = false
    
    @IBAction func clickCancle(_ sender: UIButton) {
        dismissVC(isCancle: true)
    }
    @IBAction func clickSwitch(_ sender: UISwitch) {
        if textView.isFirstResponder{
            textView.resignFirstResponder()
        }
        changeInfoForShow(sender: sender)
    }
    
    @IBAction func clickDone(_ sender: UIButton) {
        dataModel?.title = textView.text
        CustomCombinationDataManager.shared.saveCustomCombinationModelData()
        dismissVC(isCancle: false)
    }
    
    @IBAction func tapContainer(_ sender: UITapGestureRecognizer) {
        if textView.isFirstResponder{
            textView.resignFirstResponder()
        }
    }
    
    @IBAction func clickArrowBT(_ sender: UIButton) {
        if textView.isFirstResponder{
            textView.resignFirstResponder()
            
        }
        switch sender.tag {
        case 1:
            if timeSwitch.isOn{
                showTimeChooseView()
            }
        case 2:
            print(sender.tag)
        //TODO:显示 地址选择页面
        case 3:
            print(sender.tag)
            if lonlatSwitch.isOn{
                showLocationChooseView()
            }
        default:
            break
        }
    }
    
    override init() {
        super.init()
        view = (Bundle.main.loadNibNamed("CustomCombinationChooseView", owner: self, options: nil)!.first as! UIView)
        dataModel = CustomCombinationDataManager.shared.getCustomCombinationModel()
        textView.delegate = self
        //内容缩进为0（去除左右边距）
        self.textView.textContainer.lineFragmentPadding = 0
        //文本边距设为0（去除上下边距）
        self.textView.textContainerInset = .zero
        textView.layoutManager.allowsNonContiguousLayout = false
        textView.autoresizingMask = .flexibleHeight
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.scrollsToTop = false
        
        if isEditVc{
            altitudeSwitch.setOn(false, animated: false)
            weatherSwitch.setOn(false, animated: false)
            altitudeSwitch.isEnabled = false
            weatherSwitch.isEnabled = false
        }
    }
    
    
}



extension CustomCombinationChooseViewController{
    func animationBegin() {
        let timeSwitchOn = dataModel?.timeInfo?.open ?? false
        let locationSwitchOn = dataModel?.loaction?.open ?? false
        let lonlatSwitchOn = dataModel?.coord?.open ?? false
        let altitudeSwitchOn = dataModel?.altitude?.open ?? false
        let weatherSwitchOn = dataModel?.weather?.open ?? false
        
        timeSwitch.setOn(timeSwitchOn, animated: false)
        locationSwitch.setOn(locationSwitchOn, animated: false)
        lonlatSwitch.setOn(lonlatSwitchOn, animated: false)
        altitudeSwitch.setOn(altitudeSwitchOn, animated: false)
        weatherSwitch.setOn(weatherSwitchOn, animated: false)
        
        changeInfoForShow(sender: timeSwitch)
        changeInfoForShow(sender: locationSwitch)
        changeInfoForShow(sender: lonlatSwitch)
        changeInfoForShow(sender: altitudeSwitch)
        changeInfoForShow(sender: weatherSwitch)
        
        
        textView.text = dataModel?.title
        placeHolderLB.isHidden = textView.text.count>0
        sizeFitView()
        scrollViewContentHeight.constant = 380 + (textViewHeight.constant - 26)
        self.container.transform = CGAffineTransform.identity.translatedBy(x: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.curveLinear, animations: {[weak self]in
            self?.container.alpha = 1.0
            self?.container.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
        }) { (finished) in
        }
    }
    
    func dismissVC(isCancle:Bool) {
        UIView.animate(withDuration: 0.2, animations: {[weak self]in
            self?.container.transform = CGAffineTransform.identity
            self?.container.alpha = 0
        }) { [weak self](finished) in
            self?.view.removeFromSuperview()
            if let weakSelf = self{
                if isCancle{
                    self?.delegate?.CustomCombinationChooseViewControllerDelegateClickCancle()
                }else{
                    self?.delegate?.CustomCombinationChooseViewControllerDelegateClickSure(sticker: weakSelf.sticker)
                    
                }
            }
        }
    }
    
    func changeInfoForShow(sender:UISwitch){
        switch sender.tag {
        case 1:
            dataModel?.timeInfo?.open = sender.isOn
            if sender.isOn{
                setTimeChooseStyle(dataModel?.timeInfo?.style ?? 0)
            }else{
                timeLB.text = "已隐藏"
            }
        case 2:
            dataModel?.loaction?.open = sender.isOn
            if sender.isOn{
                locationLB.text = "北京市海淀区互联网金融中心"
            }else{
                locationLB.text = "已隐藏"
            }
            
        case 3:
            dataModel?.coord?.open = sender.isOn
            if sender.isOn{
                setCoordinateChooseStyle(dataModel?.coord?.style ?? 0)
            }else{
                lonlatLB.text = "已隐藏"
            }
        case 4:
            if isEditVc{
                
            }else{
                dataModel?.altitude?.open = sender.isOn
                if sender.isOn{
                    altitudeLB.text = "88 m"
                }else{
                    altitudeLB.text = "已隐藏"
                }
            }
            
        case 5:
            if isEditVc{

            }else{
                dataModel?.weather?.open = sender.isOn
                if sender.isOn{
                    weatherLB.text = "晴 28°"
                }else{
                    weatherLB.text = "已隐藏"
                }
            }
            
        default:
            break
        }
    }
    
    
}

extension CustomCombinationChooseViewController{
    func showTimeChooseView(){
        let alert = UIAlertController.init(title: "选择时间格式", message: nil, preferredStyle: .actionSheet)
        
        let act1 = UIAlertAction.init(title: "2018.10.08 18:40", style: .default) { [weak self](act1) in
            print("act1")
            self?.dataModel?.timeInfo?.style = 0
            self?.setTimeChooseStyle(0)
        }
        let act2 = UIAlertAction.init(title: "2018.10.08 星期一", style: .default) { [weak self](act2) in
            self?.dataModel?.timeInfo?.style = 1
            self?.setTimeChooseStyle(1)
        }
        let act3 = UIAlertAction.init(title: "取消", style: .cancel) { (act3) in
            print("act3")
        }
        alert.addAction(act1)
        alert.addAction(act2)
        alert.addAction(act3)
        
        CurrentViewController()?.present(alert, animated: true, completion: {
            
        })
        
    }
    func showLocationChooseView(){
        let alert = UIAlertController.init(title: "选择经纬度格式", message: nil, preferredStyle: .actionSheet)
        
        let act1 = UIAlertAction.init(title: "116.460997,39.940533", style: .default) { [weak self](act1) in
            self?.dataModel?.coord?.style = 0
            self?.setCoordinateChooseStyle(0)
        }
        let act2 = UIAlertAction.init(title: "116°27′16″E,39°56′14″N", style: .default) { [weak self](act2) in
            self?.dataModel?.coord?.style = 1
            self?.setCoordinateChooseStyle(1)
        }
        let act3 = UIAlertAction.init(title: "取消", style: .cancel) { (act3) in
            print("act3")
        }
        alert.addAction(act1)
        alert.addAction(act2)
        alert.addAction(act3)
        
        CurrentViewController()?.present(alert, animated: true, completion: {
            
        })
        
    }
    
    func setCoordinateChooseStyle(_ style:Int){
        if style == 0{
            //            if let latitude = LocationInfoManager.shared.locationCoordinate?.latitude,let longitude = LocationInfoManager.shared.locationCoordinate?.longitude{
            //                self?.lonlatLB.text = "\(latitude)" + "," + "\(longitude)"
            //            }else{
            //
            //            }
            lonlatLB.text = "122.12122123" + "," + "12.123131111"
        }else if style == 1{
            //            if let latitude = LocationInfoManager.shared.locationCoordinate?.latitude,let longitude = LocationInfoManager.shared.locationCoordinate?.longitude{
            //
            //                let a = Int(latitude)
            //                let b = Int((latitude - Double(a))*60)
            //                let c = Int((latitude - Double(a) - Double(b)/60)*3600)
            //
            //                let a1 = Int(longitude)
            //                let b1 = Int((longitude - Double(a1))*60)
            //                let c1 = Int((longitude - Double(a1) - Double(b1)/60.0)*3600)
            //                let latitudeString = "\(a)°\(b)'\(c)''\(latitude>0 ? "N" : "S")"
            //                let longitudeString = "\(a1)°\(b1)'\(c1)''\(longitude>0 ? "E" : "W")"
            //                self?.lonlatLB.text = latitudeString + "," + longitudeString
            //            }else{
            //
            //            }
            lonlatLB.text = "122E" + "," + "12N"
            
        }
    }
    
    func setTimeChooseStyle(_ style:Int){
        var dateFormat = ""
        if style == 0{
            dateFormat = "yyyy.MM.dd HH:mm"
        }else{
            dateFormat = "yyyy.MM.dd EEEE"
        }
        let str = getFormatterDate(Date(), dateFormat: dateFormat)
        timeLB.text = str
    }
    func getFormatterDate(_ date: Date,dateFormat:String) -> String {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        dateFormater.locale = Locale(identifier: "zh_CN")
        
        return dateFormater.string(from: date)
    }
    
}
extension CustomCombinationChooseViewController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLB.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeHolderLB.isHidden = textView.text.count > 0
        scrollViewContentHeight.constant = 380 + (textViewHeight.constant - 26)
        
    }
    func textViewDidChange(_ textView: UITextView) {
        sizeFitView()
    }
    
    func sizeFitView(){
        let maxHeight:CGFloat = 80
        let size = CGSize.init(width: self.textView.frame.size.width, height: CGFloat(MAXFLOAT))
        let newSize = self.textView.sizeThatFits(size)
        self.textView.layoutIfNeeded()
        if newSize.height < self.textView.frame.size.height{
            textViewHeight.constant = newSize.height
        }else{
            if newSize.height >= maxHeight{
                textViewHeight.constant = maxHeight
                textView.isScrollEnabled = true
            }else{
                textViewHeight.constant = newSize.height
                textView.isScrollEnabled = false
            }
        }
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
