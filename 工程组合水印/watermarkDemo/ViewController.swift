//
//  ViewController.swift
//  watermarkDemo
//
//  Created by 张泽 on 2018/10/24.
//  Copyright © 2018 ZFDeveloper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var constructionView: UIView!
    @IBOutlet weak var constructionIconView: UIView!
    @IBOutlet weak var construction_unitsLB: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var construction_area: UILabel!
    @IBOutlet weak var construction_content: UILabel!
    @IBOutlet weak var constractor: UILabel!
    @IBOutlet weak var supervision: UILabel!
    @IBOutlet weak var supervision_department: UILabel!
    @IBOutlet weak var takePhotoTimeLB: UILabel!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var notesLB: UILabel!
    @IBOutlet weak var build_unitsLB: UILabel!
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        
        configeCustomCombinationView()
    }
    var customCombinationView  : CustomProjectCombinationView?
    func configeCustomCombinationView(){
        customCombinationView = CustomProjectCombinationView()
        customCombinationView?.view.frame = view.bounds
        customCombinationView?.delegate = self
        view.addSubview(customCombinationView!.view)
        customCombinationView?.animationBegin()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }


}
extension ViewController:CustomProjectCombinationViewDelegate{
    func CustomProjectCombinationViewDelegateClickCancle() {
        
    }
    func CustomProjectCombinationViewDelegateClickSure(sticker: UIView?) {
        
    }
}
