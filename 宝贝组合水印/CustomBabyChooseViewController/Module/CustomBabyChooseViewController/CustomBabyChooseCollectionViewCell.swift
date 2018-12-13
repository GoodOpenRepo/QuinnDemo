//
//  CustomBabyChooseCollectionViewCell.swift
//  CustomBabyChooseViewController
//
//  Created by Quinn on 2018/10/26.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
protocol CustomBabyChooseCollectionViewCellDelegate:class {
    func CustomBabyChooseCollectionViewCellDelegateDone(name:String?,birthday:String?)
    func CustomBabyChooseCollectionViewCellDelegateClickCell()
    func CustomBabyChooseCollectionViewCellDelegateBirthResponseBT()

}


class CustomBabyChooseCollectionViewCell: UICollectionViewCell {

    @IBAction func clickBirthResponseBT(_ sender: UIButton) {
        
        delegate?.CustomBabyChooseCollectionViewCellDelegateBirthResponseBT()
        
    }
    @IBOutlet weak var birthResponseBT: UIButton!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var name: UITextField!
    weak var delegate:CustomBabyChooseCollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        name.delegate = self
        birthday.delegate = self
        
    }

    func setupData(model:WatermarkBabyModel?){
        guard let _model = model else {
            return
        }
        
        if _model.index == BabyDataManager.shared.placeHolderIndex{
            let dateFormat = "yyyy.MM.dd"
            let str = getFormatterDate(Date(), dateFormat: dateFormat)
            birthday.text = str
            name.text = _model.name
        }else{
            name.text = _model.name
            let dateFormat = "yyyy.MM.dd"
            let str = getFormatterDate(Date(), dateFormat: dateFormat)
            birthday.text = str
        }
    }

    func getFormatterDate(_ date: Date,dateFormat:String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        dateFormater.locale = Locale(identifier: "zh_CN")
        return dateFormater.string(from: date)
    }
}
extension CustomBabyChooseCollectionViewCell:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.CustomBabyChooseCollectionViewCellDelegateClickCell()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.CustomBabyChooseCollectionViewCellDelegateDone(name: name.text, birthday: birthday.text)
    }
}
