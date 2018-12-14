//
//  CustomObserverViewController.swift
//  RxDemo
//
//  Created by Quinn on 2018/12/14.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class CustomObserverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    func customUIBinderProperty(){
        //五、自定义可绑定属性

//        有时我们想让 UI 控件创建出来后默认就有一些观察者，而不必每次都为它们单独去创建观察者。比如我们想要让所有的 UIlabel 都有个 fontSize 可绑定属性，它会根据事件值自动改变标签的字体大小。
//        方式一：通过对 UI 类进行扩展
//        （1）这里我们通过对 UILabel 进行扩展，增加了一个 fontSize 可绑定属性。
//        extension UILabel {
//            public var fontSize: Binder<CGFloat> {
//                return Binder(self) { label, fontSize in
//                    label.font = UIFont.systemFont(ofSize: fontSize)
//                }
//            }
//        }
        
//        Observable序列（每隔0.5秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
//        observable
//            .map { CGFloat($0) }
//            .bind(to: label.fontSize) //根据索引数不断变放大字体
//            .disposed(by: disposeBag)

        
//        方式二：通过对 Reactive 类进行扩展
//        既然使用了 RxSwift，那么更规范的写法应该是对 Reactive 进行扩展。这里同样是给 UILabel 增加了一个 fontSize 可绑定属性。
//        extension Reactive where Base: UILabel {
//            public var fontSize: Binder<CGFloat> {
//                return Binder(self.base) { label, fontSize in
//                    label.font = UIFont.systemFont(ofSize: fontSize)
//                }
//            }
//        }
        
        
        //六、RxSwift 自带的可绑定属性（UI 观察者）
//        （1）其实 RxSwift 已经为我们提供许多常用的可绑定属性。比如 UILabel 就有 text 和 attributedText 这两个可绑定属性。
//        （2）那么上文那个定时显示索引数的样例，我们其实不需要自定义 UI 观察者，直接使用 RxSwift 提供的绑定属性即可。

//        //Observable序列（每隔1秒钟发出一个索引数）
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable
//            .map { "当前索引数：\($0 )"}
//            .bind(to: label.rx.text) //收到发出的索引数后显示到label上
//            .disposed(by: disposeBag)
        
        
    }

}
