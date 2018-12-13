//
//  CustomCombinationView.swift
//  watermarkDemo
//
//  Created by 张泽 on 2018/10/25.
//  Copyright © 2018 ZFDeveloper. All rights reserved.
//

import UIKit
protocol CustomProjectCombinationViewDelegate : class {
    func CustomProjectCombinationViewDelegateClickCancle()
    func CustomProjectCombinationViewDelegateClickSure(sticker:UIView?)
}

class CustomProjectCombinationView: NSObject {
    
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var nameSwitch: UISwitch!
    @IBOutlet weak var areaLB: UILabel!
    @IBOutlet weak var areaSwitch: UISwitch!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var contentSwitch: UISwitch!
    @IBOutlet weak var peopleLB: UILabel!
    @IBOutlet weak var peopleSwitch: UISwitch!
    @IBOutlet weak var supervisionLB: UILabel!
    @IBOutlet weak var supervisionSwitch: UISwitch!
    @IBOutlet weak var currentTimeLB: UILabel!
    @IBOutlet weak var currentTimeSwitch: UISwitch!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var constructionUnitsLB: UILabel!
    @IBOutlet weak var constructionUnitsSwitch: UISwitch!
    @IBOutlet weak var supervisionUnitsLB: UILabel!
    @IBOutlet weak var supervisionUnitsSwitch: UISwitch!
    @IBOutlet weak var buildUnitsLB: UILabel!
    @IBOutlet weak var buildUnitsSwitch: UISwitch!
    @IBOutlet weak var otherInfoTF: UITextField!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputTF: UITextField!
    @IBOutlet weak var inputTitle: UILabel!
    
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var inputTapView: UIView!
    weak var delegate : CustomProjectCombinationViewDelegate?
    var sticker : UIView?
    var dataModel:CustomProjectWaterModel?
    var currentTag = -1
    @IBAction func clickCancle(_ sender: UIButton) {
        dismissVC(isCancle: true)
        
    }
    
    @IBAction func tapToHiddenKeyboard(_ sender: UITapGestureRecognizer) {
        afterKeyboardHidden()
    }
    
    func afterKeyboardHidden(){
        view.endEditing(true)
        inputContainerViewBottom.constant = 0
        inputTapView.isHidden = true
        inputContainerView.isHidden = true
        if currentTag == 0{
            otherInfoTF.text = inputTF.text
            setInfoByTag(tag: currentTag, info: inputTF.text ?? "")
        }
        guard let controlLB = scrollContentView.viewWithTag(currentTag+40) as? UILabel else{
            return
        }
        guard let controlSwitch = scrollContentView.viewWithTag(currentTag) as? UISwitch else{
            return
        }
        if let info = inputTF.text,info != ""{
            controlLB.text = info
            setInfoByTag(tag: currentTag, info: info)
        }else{
            controlSwitch.setOn(false, animated: true)
            controlLB.text = "已隐藏"
            setOpenByTag(tag: currentTag, open: false)
        }
    }
    @IBAction func clickDone(_ sender: UIButton) {
        CustomProjectCombinationDataManager.shared.saveCustomCombinationModelData()
        dismissVC(isCancle: false)
    }
    
    @IBAction func clickArrowBT(_ sender: UIButton) {
        let switchTag = sender.tag-20
        currentTag = switchTag
        guard let controlSwitch = scrollContentView.viewWithTag(switchTag) as? UISwitch else{
            return
        }
        controlSwitch.setOn(true, animated: true)
        responseUI(tag: switchTag, forceEdit: true)

    }
    @IBAction func otherInfoInput(_ sender: UIButton) {
        inputContainerView.isHidden = false
        inputTF.becomeFirstResponder()
        let inputShowInfo = "备注信息"
        inputTitle.text = inputShowInfo
        inputTF.placeholder = "输入\(inputShowInfo)..."
        inputTapView.isHidden = false
        otherInfoTF.text = nil
        inputTF.text = nil
        currentTag = 0
    }
    
    
    @IBAction func clickSwitch(_ sender: UISwitch) {
        currentTag = sender.tag
        responseUI(tag: sender.tag, forceEdit: false )
    }
    
    
    func responseUI(tag:Int,forceEdit:Bool){
        var forceEdit = forceEdit
        guard let controlLB = scrollContentView.viewWithTag(tag+40) as? UILabel else{
            
            return
        }
        guard let controlSwitch = scrollContentView.viewWithTag(tag) as? UISwitch else{
            return
        }
        setOpenByTag(tag: tag, open: controlSwitch.isOn)
        if controlSwitch.isOn {
            
            if let info = getInfoFromDataModel(tag: tag),info != ""{
                controlLB.text = info
            }else{
                forceEdit = true
            }
            if forceEdit {
                switch tag{
                case 6:
                    showTimeClooseView()
                case 7:
//                    showLocationChooseView()
                    //打开地点
                    break
                default:
                    inputContainerView.isHidden = false
                    inputTF.becomeFirstResponder()
                    let inputShowInfo = getTitleByTag(tag)
                    inputTitle.text = inputShowInfo
                    inputTF.placeholder = "输入\(inputShowInfo ?? "")..."
                    inputTapView.isHidden = false
                    controlLB.text = nil
                    inputTF.text = nil
                }

            }
            
        }else{
            controlLB.text = "已隐藏"
        }

        
    }
    func getTitleByTag( _ tag:Int)->String?{
        var str:String? = ""
        switch tag {
        case 0:
            str = "备注信息"
        case 1:
            str = "工程名称"
        case 2:
            str = "施工区域"
        case 3:
            str = "施工内容"
        case 4:
            str = "施工员"
        case 5:
            str = "监理"
        case 6:
            str = "拍摄时间"
        case 7:
            str = "地点"
        case 8:
            str = "施工单位"
        case 9:
            str = "监理单位"
        case 10:
            str = "建设单位"
            
        default:
            break
        }
        return str
    }
    
    
    func getInfoFromDataModel(tag:Int)->String?{
        var str:String? = ""
        switch tag {
        case 0:
            str = dataModel?.otherInfo
        case 1:
            str = dataModel?.name?.content
        case 2:
            str = dataModel?.area?.content
        case 3:
            str = dataModel?.content?.content
        case 4:
            str = dataModel?.people?.content
        case 5:
            str = dataModel?.supervision?.content
        case 6:
            str = setTimeChooseStyle(dataModel?.currentTime?.style ?? 0)
        case 7:
            str = dataModel?.location?.content
        case 8:
            str = dataModel?.constructionUnit?.content
        case 9:
            str = dataModel?.supervisionUnit?.content
        case 10:
            str = dataModel?.buildUnit?.content

        default:
            break
        }
        return str
    }
    func setInfoByTag(tag:Int,info:String){
        let str:String = info
        switch tag {
        case 0:
            dataModel?.otherInfo = str
        case 1:
            dataModel?.name?.content = str
        case 2:
            dataModel?.area?.content = str

        case 3:
            dataModel?.content?.content = str

        case 4:
            dataModel?.people?.content = str

        case 5:
            dataModel?.supervision?.content = str

        case 6:
            dataModel?.currentTime?.content = str

        case 7:
            dataModel?.location?.content = str

        case 8:
            dataModel?.constructionUnit?.content = str

        case 9:
            dataModel?.supervisionUnit?.content = str

        case 10:
            dataModel?.buildUnit?.content = str

        default:
            break
        }
    }

    func setOpenByTag(tag:Int,open:Bool){
        switch tag {
        case 0:
            break
        case 1:
            dataModel?.name?.open = open
        case 2:
            dataModel?.area?.open = open
            
        case 3:
            dataModel?.content?.open = open
            
        case 4:
            dataModel?.people?.open = open
            
        case 5:
            dataModel?.supervision?.open = open
            
        case 6:
            dataModel?.currentTime?.open = open
            
        case 7:
            dataModel?.location?.open = open
            
        case 8:
            dataModel?.constructionUnit?.open = open
            
        case 9:
            dataModel?.supervisionUnit?.open = open
            
        case 10:
            dataModel?.buildUnit?.open = open
            
        default:
            break
        }
    }
    func animationBegin(){
        loadData()
        addKeyboardNotification()
        //取值
        let nameSwitchOn = dataModel?.name?.open ?? false
        let areaSwitchOn = dataModel?.area?.open ?? false
        let contentSwitchOn = dataModel?.content?.open ?? false
        let peopleSwitchOn = dataModel?.people?.open ?? false
        let supervisionSwitchOn = dataModel?.supervision?.open ?? false
        let currentTimeSwitchOn = dataModel?.currentTime?.open ?? false
        let locationSwitchOn = dataModel?.location?.open ?? false
        let constructionUnitSwitchOn = dataModel?.constructionUnit?.open ?? false
        let supervisionUnitSwitchOn = dataModel?.supervisionUnit?.open ?? false
        let buildUnitSwitchOn = dataModel?.buildUnit?.open ?? false
        
        //赋值
        nameSwitch.setOn(nameSwitchOn, animated: false)
        areaSwitch.setOn(areaSwitchOn, animated: false)
        contentSwitch.setOn(contentSwitchOn, animated: false)
        peopleSwitch.setOn(peopleSwitchOn, animated: false)
        supervisionSwitch.setOn(supervisionSwitchOn, animated: false)
        currentTimeSwitch.setOn(currentTimeSwitchOn, animated: false)
        locationSwitch.setOn(locationSwitchOn, animated: false)
        constructionUnitsSwitch.setOn(constructionUnitSwitchOn, animated: false)
        supervisionUnitsSwitch.setOn(supervisionUnitSwitchOn, animated: false)
        buildUnitsSwitch.setOn(buildUnitSwitchOn, animated: false)
        otherInfoTF.text = dataModel?.otherInfo
        
        changeInfoForShow(sender: nameSwitch, contentLB: nameLB, content: dataModel?.name?.content)
        changeInfoForShow(sender: areaSwitch, contentLB: areaLB, content: dataModel?.area?.content)
        changeInfoForShow(sender: contentSwitch, contentLB: contentLB, content: dataModel?.content?.content)
        changeInfoForShow(sender: peopleSwitch, contentLB: peopleLB, content: dataModel?.people?.content)
        changeInfoForShow(sender: supervisionSwitch, contentLB: supervisionLB, content: dataModel?.supervision?.content)
        changeInfoForShow(sender: currentTimeSwitch, contentLB: currentTimeLB, content: dataModel?.currentTime?.content,style:dataModel?.currentTime?.style ?? 0)
        changeInfoForShow(sender: locationSwitch, contentLB: locationLB, content: dataModel?.location?.content,style:dataModel?.currentTime?.style ?? 0)
        changeInfoForShow(sender: constructionUnitsSwitch, contentLB: constructionUnitsLB, content: dataModel?.constructionUnit?.content)
        changeInfoForShow(sender: supervisionUnitsSwitch, contentLB: supervisionUnitsLB, content: dataModel?.supervisionUnit?.content)
        changeInfoForShow(sender: buildUnitsSwitch, contentLB: buildUnitsLB, content: dataModel?.buildUnit?.content)

        //动画
        self.container.transform = CGAffineTransform.identity.translatedBy(x: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIView.AnimationOptions.curveLinear, animations: {[weak self]in
            self?.container.alpha = 1.0
            self?.container.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
        }) { (finished) in
        }
    }
    func dismissVC(isCancle:Bool){
        removeKeyboardNotification()
        UIView.animate(withDuration: 0.2, animations: {[weak self]in
            self?.container.transform = CGAffineTransform.identity
            self?.container.alpha = 0
        }){ [weak self](finished) in
            self?.view.removeFromSuperview()
            if let weakSelf = self{
                if isCancle{
                  self?.delegate?.CustomProjectCombinationViewDelegateClickCancle()
                }else{
                  self?.delegate?.CustomProjectCombinationViewDelegateClickSure(sticker: weakSelf.sticker)
                    
                }
            }
        }
    }
    override init() {
        super.init()
        view = (Bundle.main.loadNibNamed("CustomProjectCombinationView", owner: self, options: nil)!.first as! UIView)
        inputTF.delegate = self
        let path = UIBezierPath.init(roundedRect: inputContainerView.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.frame = inputContainerView.bounds
        inputContainerView.layer.mask = mask
        
    }

 
    
    
    
    

    func loadData(){
        dataModel = CustomProjectCombinationDataManager.shared.getCustomProjectCombinationModel()
    }
    
    
    //改变显示内容
    func changeInfoForShow(sender:UISwitch,contentLB:UILabel,content:String?,style:Int = 0){
        if sender.isOn{
            contentLB.text = content
            if sender.tag == 6{
                contentLB.text = setTimeChooseStyle(style)
            }
        }else{
            contentLB.text = "已隐藏"
        }
    }
    
    
    
    
    
    
    
}
