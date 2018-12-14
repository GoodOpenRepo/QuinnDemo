//
//  MusicViewController.swift
//  RxDemo
//
//  Created by Quinn on 2018/12/13.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class MusicViewController: UIViewController {
    
    //tableView对象
    @IBOutlet weak var tableView: UITableView!
    
    //歌曲列表数据源
    let musicListViewModel = MusicListViewModel()
    
    //负责对象销毁
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicListViewModel.data.bind(to: tableView.rx.items(cellIdentifier: "musicCell")){ _,music,cell in
            cell.textLabel?.text = music.name
            cell.detailTextLabel?.text = music.singer
            
        }.disposed(by: disposeBag)
        //将数据源数据绑定到tableView上
        //tableView点击响应
        tableView.rx.modelSelected(Music.self).subscribe(onNext: {music in
                print("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)

        
//        //设置代理
//        tableView.dataSource = self
//        tableView.delegate = self
    }
}

//extension MusicViewController: UITableViewDataSource {
//    //返回单元格数量
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return musicListViewModel.data.count
//    }
//
//    //返回对应的单元格
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
//        -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell")!
//            let music = musicListViewModel.data[indexPath.row]
//            cell.textLabel?.text = music.name
//            cell.detailTextLabel?.text = music.singer
//            return cell
//    }
//}
//
//extension MusicViewController: UITableViewDelegate {
//    //单元格点击
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("你选中的歌曲信息【\(musicListViewModel.data[indexPath.row])】")
//    }
//}
