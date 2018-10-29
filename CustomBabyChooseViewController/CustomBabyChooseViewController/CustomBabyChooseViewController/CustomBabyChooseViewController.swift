//
//  CustomBabyChooseViewController.swift
//  CustomBabyChooseViewController
//
//  Created by Quinn on 2018/10/26.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
protocol CustomBabyChooseViewControllerDelegate:class {
    func CustomBabyChooseViewControllerDelegateClickCancle()
    func CustomBabyChooseViewControllerDelegateClickSure(sticker: UIView?)

}

class CustomBabyChooseViewController: NSObject {

    @IBOutlet weak var addBTTrailing: NSLayoutConstraint!
    weak var delegate:CustomBabyChooseViewControllerDelegate?
    var sticker:UIView?
        @IBOutlet var view: UIView!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var controlBar: UIView!
    @IBOutlet weak var deleteBT: UIButton!
    @IBOutlet weak var addBT: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var doneBT: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var datePickerContentView: UIView!
    var currentIndexPath:IndexPath?
    
    var watermarkBabyModels:WatermarkBabyModels?

    @IBAction func tapDatePickerViewContainer(_ sender: UITapGestureRecognizer) {
        datePickerContentView.isHidden = true

    }
    override init() {
        super.init()
        view = (Bundle.main.loadNibNamed("CustomBabyChooseView", owner: self, options: nil)!.first as! UIView)
        loadCollectionView()
        datePickerView.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func tapedView(_ sender: UITapGestureRecognizer) {
        collectionView.endEditing(true)
    }
    @IBAction func doneDatePicker(_ sender: UIButton) {
    
        datePickerContentView.isHidden = true
    
    }
    @IBAction func delete(_ sender: UIButton) {
        guard let index = currentIndexPath?.row else {
            return
        }
        guard (watermarkBabyModels?.models.count ?? 0) > index,let _ = watermarkBabyModels?.models[index] else {
            return
        }
        
        BabyDataManager.shared.removeModel(index: index)
        
        if watermarkBabyModels?.models.count == 0{
            addPlaceHolder()
            deleteBT.isUserInteractionEnabled = false
            addBT.isUserInteractionEnabled = true
            addBT.isSelected = false
            changeUI(showMoreControl: false)
        }else{
            pageControl.numberOfPages = watermarkBabyModels?.models.count ?? 0
            deleteBT.isUserInteractionEnabled = true
            changeUI(showMoreControl: true)

        }
        
        collectionView.reloadData()

    }
    
    @IBAction func add(_ sender: UIButton) {
        var needReload = true
        if watermarkBabyModels?.models.last?.index == BabyDataManager.shared.placeHolderIndex{
            needReload = changeModel()
        }
        if needReload{
            changeUI(showMoreControl: true)
            addPlaceHolder()
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            if let models = watermarkBabyModels?.models,models.count > 0{
                let indexPath = IndexPath.init(row: models.count-1, section: 0)
                pageControl.numberOfPages = indexPath.row + 1
                pageControl.currentPage =  indexPath.row
                collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
                if models.count >= 5{
                    addBT.isUserInteractionEnabled = false
                    addBT.isSelected = true
                }
            }
        }
        
    }

    func changeUI(showMoreControl:Bool) {
        
        if showMoreControl{
            addBTTrailing.constant = 10
            addBT.setTitle("添加", for: .normal)
            self.view.layoutIfNeeded()
            self.deleteBT.isHidden = false
            self.pageControl.isHidden = false
        }else{
            addBTTrailing.constant = 110
            deleteBT.isHidden = true
            pageControl.isHidden = true
            addBT.setTitle("添加宝宝", for: .normal)
        }
        
    }
    
    @IBAction func done(_ sender: UIButton) {
        if changeModel(){
            collectionView.reloadData()
            dismissVC(isCancle: false)
        }
    }
    
    func changeModel()->Bool{
        guard let indexPath = currentIndexPath else{
            showInfoError()
            return false
        }
        let cell = collectionView.cellForItem(at: indexPath) as! CustomBabyChooseCollectionViewCell
        guard let name = cell.name.text ,name != "" else {
            showInfoError()
            return false
        }
        guard  let birth = cell.birthday.text,birth != "" else {
            showInfoError()
            return false
        }
        
        let model = WatermarkBabyModel.init(_name: name, _birth: birth, _index: indexPath.row)
        BabyDataManager.shared.removePlaceHolderModel()
        BabyDataManager.shared.updateModel(newModel: model)

        
        return true
    }
    func showInfoError(){
        print("请完善宝宝信息")
    }
    
    @IBAction func cancle(_ sender: Any) {
        
        dismissVC(isCancle: true)
    }
    
    @IBAction func datePickValueChange(_ sender: UIDatePicker) {
        guard let indexPath = currentIndexPath else{
            showInfoError()
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as! CustomBabyChooseCollectionViewCell
        
        cell.birthday.text = getFormatterDate(datePickerView.date, dateFormat: "yyyy.MM.dd")
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didScrollEnd(scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didScrollEnd(scrollView)
        
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        didScrollEnd(scrollView)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollEnd(scrollView)
    }
    
    func didScrollEnd(_ scrollView: UIScrollView){
        let index = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = index
        currentIndexPath = IndexPath.init(row: index, section: 0)
    }
    
    
    func getFormatterDate(_ date: Date,dateFormat:String) -> String {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        dateFormater.locale = Locale(identifier: "zh_CN")
        
        return dateFormater.string(from: date)
    }
    
}
extension CustomBabyChooseViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return watermarkBabyModels?.models.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomBabyChooseCollectionViewCell", for: indexPath) as! CustomBabyChooseCollectionViewCell
        cell.delegate = self
        cell.setupData(model: watermarkBabyModels?.models[indexPath.row])
        return cell
    }
    

    
    func loadCollectionView(){
        collectionView.register(UINib.init(nibName: "CustomBabyChooseCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CustomBabyChooseCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
    }
    
    func addPlaceHolder(){
        BabyDataManager.shared.addPlaceHolderModel()
        watermarkBabyModels = BabyDataManager.shared.watermarkBabyModels
    }
    
}
extension CustomBabyChooseViewController{
    func animationBegin() {
        watermarkBabyModels = BabyDataManager.shared.getWatermarkBabyModel()
        if watermarkBabyModels == nil || watermarkBabyModels?.models.count == 0 {
            addPlaceHolder()
            changeUI(showMoreControl: false)
        }else{
            pageControl.currentPage = 0
            pageControl.numberOfPages = watermarkBabyModels?.models.count ?? 0
            changeUI(showMoreControl: true)
        }
        if watermarkBabyModels?.models.count == 5{
            addBT.isSelected = true
            addBT.isUserInteractionEnabled = false

        }
        currentIndexPath = IndexPath.init(row: 0, section: 0)
        collectionView.reloadData()


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
            if isCancle{
                self?.delegate?.CustomBabyChooseViewControllerDelegateClickCancle()
            }else{
                self?.delegate?.CustomBabyChooseViewControllerDelegateClickSure(sticker: self?.sticker)
                
            }
        }
    }
}
extension CustomBabyChooseViewController:CustomBabyChooseCollectionViewCellDelegate{
    func CustomBabyChooseCollectionViewCellDelegateBirthResponseBT() {
        
        collectionView.isScrollEnabled = false
        datePickerContentView.isHidden = false
    }
    
    
    func CustomBabyChooseCollectionViewCellDelegateDone(name: String?, birthday: String?) {
        collectionView.isScrollEnabled = true
        if let model = watermarkBabyModels?.models[currentIndexPath?.row ?? 0]{
            model.birth = birthday ?? ""
            model.name = name ?? ""
        }
    }
    
    func CustomBabyChooseCollectionViewCellDelegateClickCell(){
        collectionView.isScrollEnabled = false
    }
    
    
}
