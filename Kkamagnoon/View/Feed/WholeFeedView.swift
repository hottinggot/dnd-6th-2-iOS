//
//  WholeFeedView.swift
//  Kkamagnoon
//
//  Created by 서정 on 2022/02/08.
//

import UIKit
import RxSwift
import RxCocoa

class WholeFeedView: FeedView {

    override func setFilterView() {
        filterView = TagListView()
        self.addSubview(filterView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        filterView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        filterView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        filterView.heightAnchor.constraint(equalToConstant: 29).isActive = true

//        filterView..rx.itemSelected
//            .bind { [weak self] indexPath in
//
//                guard let self = self else { return }
//                self.filterView.selectItem(at: indexPath, animated: false, scrollPosition: [])
//            }
//            .disposed(by: disposeBag)

    }

    override func setSortButton() {
        sortButton.setTitle("인기순", for: .normal)
        sortButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        sortButton.sizeToFit()
        sortButton.titleLabel?.font = UIFont.pretendard(weight: .medium, size: 12)

        self.addSubview(sortButton)

        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 22).isActive = true
        sortButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -27).isActive = true
    }
}