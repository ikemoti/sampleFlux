//
//  GithubSearchViewController.swift
//  sampleFlux
//
//  Created by Sousuke Ikemoto on 2021/01/12.
//

import Foundation
import UIKit
import RxSwift
import ReactorKit

//UIの本接続やらない　とりあえずどんな感じで動くかだけ
class GithubSearchViewController: UIViewController, StoryboardView {
    let tableView: UITableView = .init()
    let searchBar: UISearchBar = .init()
    let searchController = UISearchController(searchResultsController: nil)
    var disposeBag = DisposeBag()
    
    
    func bind(reactor: GithubSearchReactor) {
        searchController.searchBar.rx.text
             .throttle(.milliseconds(300), scheduler: MainScheduler.instance)//入力が止まってから3秒後に
             .map { Reactor.Action.updateQuery($0) }//Action生成
             .bind(to: reactor.action)
             .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .filter { [weak self] offset in
                   guard let `self` = self else { return false }
                   guard self.tableView.frame.height > 0 else { return false }
                   return offset.y + self.tableView.frame.height >= self.tableView.contentSize.height - 100
                 }
                 .map { _ in Reactor.Action.loadNextPage }
                 .bind(to: reactor.action)
                 .disposed(by: disposeBag)
        
        reactor.state.map { $0.repos }
             .bind(to: tableView.rx.items(cellIdentifier: "cell")) { indexPath, repo, cell in
               cell.textLabel?.text = repo
             }
             .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
             .subscribe(onNext: { [weak self, weak reactor] indexPath in
               guard let `self` = self else { return }
               self.view.endEditing(true)
               self.tableView.deselectRow(at: indexPath, animated: false)
               guard let repo = reactor?.currentState.repos[indexPath.row] else { return }
               guard let url = URL(string: "https://github.com/\(repo)") else { return }
             
             })
             .disposed(by: disposeBag)
        
    }
    
    
    
}


