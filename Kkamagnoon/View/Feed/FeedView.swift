//
//  FeedView.swift
//  Kkamagnoon
//
//  Created by 서정 on 2022/02/08.
//

import UIKit
import RxSwift
import RxCocoa

//protocol FeedViewProtocol {
//    func setFilterView()
//
//    func setSortButton()
//
//    func setFeedMainView()
//}

class FeedView: UIView {

    var filterView: UICollectionView!
    
    lazy var searchButton: UIButton = UIButton()
    lazy var bellButton: UIButton = UIButton()
    
    lazy var sortButton: UIButton = UIButton()
    lazy var feedMainView: FeedMainView = FeedMainView()
  
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setFilterView()
        setSortButton()
        setFeedMainView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFilterView() { }

    func setSortButton() { }
    
    func setFeedMainView() {
        addSubview(feedMainView)
        feedMainView.translatesAutoresizingMaskIntoConstraints = false
        
//        feedMainView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 11.83).isActive = true
        
        feedMainView.topAnchor.constraint(equalTo: self.filterView.bottomAnchor, constant: 11.83).isActive = true
        
        feedMainView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        feedMainView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        feedMainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let dummyData = Observable<[String]>.of(["글감", "일상", "로맨스", "짧은 글", "긴 글", "무서운 글", "발랄한 글", "한글", "세종대왕"])

        dummyData.bind(to: feedMainView.feedCollectionView
                        .rx.items(cellIdentifier: CellIdentifier.feed,
                                             cellType: FeedCell.self)) { (_, element, cell) in
            cell.backgroundColor = .blue
            cell.articleTitle.text = element
            cell.layer.cornerRadius = 15
            }
        .disposed(by: disposeBag)
        
        feedMainView.feedCollectionView.rx
            .itemSelected
            .bind { _ in
                let vc = DetailContentViewController()
                vc.modalPresentationStyle = .pageSheet
                vc.hidesBottomBarWhenPushed = true
                
                self.viewController?.navigationController?.pushViewController(vc, animated: true)

            }
            .disposed(by: disposeBag)
    }
}


