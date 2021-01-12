//
//  ViewController.swift
//  sampleFlux
//
//  Created by Sousuke Ikemoto on 2021/01/01.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class CountViewController: UIViewController, StoryboardView {
    @IBOutlet weak var increasebutton: UIButton!
    @IBOutlet weak var decreasebutton: UIButton!
    @IBOutlet weak var indicatorview: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: CounterViewReactor){
        increasebutton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)         
            .disposed(by: disposeBag)
        
        decreasebutton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // .distinctUntilChanged()??
        reactor.state.map { $0.value }
             .distinctUntilChanged()
             .map { "\($0)" }
             .bind(to: label.rx.text)
             .disposed(by: disposeBag)

           reactor.state.map { $0.isLoading }
             .distinctUntilChanged()
             .bind(to: indicatorview.rx.isAnimating)
             .disposed(by: disposeBag)
        }
    
    
    
    


}

