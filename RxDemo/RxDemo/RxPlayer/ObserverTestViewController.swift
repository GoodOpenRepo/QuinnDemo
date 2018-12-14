//
//  ObserverTestViewController.swift
//  RxDemo
//
//  Created by Quinn on 2018/12/14.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ObserverTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func what_is_observer(){
//        观察者（Observer）的作用就是监听事件，然后对这个事件做出响应。或者说任何响应事件的行为都是观察者。比如：
//        当我们点击按钮，弹出一个提示框。那么这个“弹出一个提示框”就是观察者 Observer<Void>
//        当我们请求一个远程的 json 数据后，将其打印出来。那么这个“打印 json 数据”就是观察者 Observer<JSON>
//
    }
    func creatObservale(){
//        二、直接在 subscribe、bind 方法中创建观察者
//        1，在 subscribe 方法中创建
//        （1）创建观察者最直接的方法就是在 Observable 的 subscribe 方法后面描述当事件发生时，需要如何做出响应。
//        （2）比如下面的样例，观察者就是由后面的 onNext，onError，onCompleted 这些闭包构建出来的。
        
//        let observable = Observable.of("A", "B", "C")
//
//        observable.subscribe(onNext: { element in
//            print(element)
//        }, onError: { error in
//            print(error)
//        }, onCompleted: {
//            print("completed")
//        })
        
//        2，在 bind 方法中创建
        //Observable序列（每隔1秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//
//        observable
//            .map { "当前索引数：\($0 )"}
//            .bind { [weak self](text) in
//                //收到发出的索引数后显示到label上
//                self?.label.text = text
//            }
//            .disposed(by: disposeBag)
        
        
//        三、使用 AnyObserver 创建观察者
//        1，配合 subscribe 方法使用
//        比如上面第一个样例我们可以改成如下代码：

//        let observer: AnyObserver<String> = AnyObserver { (event) in
//            switch event {
//            case .next(let data):
//                print(data)
//            case .error(let error):
//                print(error)
//            case .completed:
//                print("completed")
//            }
//        }
//
//        let observable = Observable.of("A", "B", "C")
//        observable.subscribe(observer)
        
//        四、使用 Binder 创建观察者
//        1，基本介绍
//        （1）相较于 AnyObserver 的大而全，Binder 更专注于特定的场景。Binder 主要有以下两个特征：
//        不会处理错误事件
//        确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
//        （2）一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
        let label = UILabel()
        let observer:Binder<String> = Binder(label){view,text in
            view.text = text
        }
        let observable = Observable<Int>.of(1,2,3,4,5)
        observable
            .map { "当前索引数：\($0 )"}
            .bind(to: observer).disposed(by: DisposeBag())
        
        
    }

}
