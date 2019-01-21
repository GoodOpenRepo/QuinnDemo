//
//  BottleListViewController.swift
//  UIRefreshConrtolDemo
//
//  Created by Quinn on 2019/1/8.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit
import MJRefresh
class BottleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var bottleList:[NewBottleInfo]?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        self.navigationController?.navigationBar.isHidden = true
        requestBottleList { [weak self](list) in
            self?.bottleList = list
            self?.tableView.reloadData()
        }
        
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let header = MJRefreshNormalHeader.init(refreshingBlock: {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.tableView.mj_header.endRefreshing()
            }
        })
        header?.stateLabel.textColor = .white
        header?.activityIndicatorViewStyle = .white
        header?.lastUpdatedTimeLabel.textColor = .white
        self.tableView.mj_header = header
    }
}
extension BottleListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottleList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottleListCell", for: indexPath) as! BottleListCell
        let info = bottleList?[indexPath.row]
        cell.nameLB.text = "来自" + (info?.addr ?? "未知位置")
        cell.infoHint.isHidden = info?.is_read ?? true

        //回复的是icon 且没有最新回复 明天与骆姐商量
        if let tag = info?.reply_icon,info?.first_txt == ""{
            switch tag{
            case 0:
                cell.contentLB.text = "👍"
            case 1:
                cell.contentLB.text = "😍"
            case 2:
                cell.contentLB.text = "😭"
            case 3:
                cell.contentLB.text = "😡"
            default:
                break
            }
        }else{
            if info?.first_txt != "", info?.last_txt == ""{
                cell.contentLB.text = info?.first_txt
            }else{
                cell.contentLB.text = info?.last_txt
            }
        }
        switch info?.sex {
            case 0:
            cell.genderImage.image = UIImage(named: "bottle_gender_male")
            case 1:
            cell.genderImage.image = UIImage(named: "bottle_gender_female")
            case 2:
            cell.genderImage.image = nil
            default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bottleInfo = bottleList?[indexPath.row] else{
            return
        }
        let bottleChatVc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "BottleChatViewController") as! BottleChatViewController
        bottleChatVc.bottleInfo = bottleInfo
        tableView.reloadRows(at: [indexPath], with: .none)
        self.navigationController?.pushViewController(bottleChatVc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

