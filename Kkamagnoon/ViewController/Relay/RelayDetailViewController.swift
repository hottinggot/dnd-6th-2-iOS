//
//  RelayDetailViewController.swift
//  Kkamagnoon
//
//  Created by 서정 on 2022/02/14.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class RelayDetailViewController: UIViewController {

    var disposeBag = DisposeBag()

    let viewModel = RelayDetailViewModel()

    var detailView = RelayDetailView()
        .then {
            $0.relayWritingList.collectionView.register(
                RelayContentCell.self,
                forCellWithReuseIdentifier: RelayContentCell.relayContentCellIdentifier
            )

            $0.relayWritingList.collectionView.register(
                RelayTitleCell.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: RelayTitleCell.relayTitleCellIdentifier
            )

            $0.relayWritingList.layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 541)

        }

    let dataSource = RxCollectionViewSectionedReloadDataSource<FeedSection>(configureCell: { _, collectionView, indexPath, element in

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelayContentCell.relayContentCellIdentifier, for: indexPath) as! RelayContentCell

        cell.subTitleLabel.text = element.title
        cell.contentTextLabel.setTextWithLineHeight(text: element.content, lineHeight: Numbers(rawValue: 24.0) ?? .lineheightInBox)

        return cell

    }, configureSupplementaryView: { dataSource, collectionView, _, indexPath in
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RelayTitleCell.relayTitleCellIdentifier, for: indexPath) as! RelayTitleCell

        let sectionModel = dataSource.sectionModels[indexPath.section].header

        headerView.titleLabel.text = sectionModel.title
        headerView.totalCountLabel.text = "총 \(sectionModel.articleCount ?? 0)편"

        return headerView
    })

    lazy var enterButton = UIButton()
        .then {
            $0.backgroundColor = UIColor(rgb: Color.whitePurple)
            $0.setTitle("방 입장하기", for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(weight: .medium, size: 18)
            $0.setTitleColor(UIColor(rgb: 0xF0F0F0), for: .normal)
            $0.layer.cornerRadius = 10
        }

    lazy var addWritingButton = MakingRoomButton()
        .then {
            $0.setImage(UIImage(named: "Pencil"), for: .normal)
        }

    lazy var bottomBar = BottomBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: Color.basicBackground)
        navigationController?.isNavigationBarHidden = true

        setDetailView()

        if viewModel.isNew || viewModel.didEntered {
            setBottomBar()
            setAddWritingButton()
        } else {
            setEnterButton()
        }
        bindView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addWritingButton.layer.cornerRadius = addWritingButton.frame.size.width / 2
    }

    func setDetailView() {

        view.addSubview(detailView)

        detailView.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setEnterButton() {
        view.addSubview(enterButton)

        enterButton.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-40.0)
            $0.height.equalTo(56.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40.0)
        }
    }

    func setBottomBar() {
        view.addSubview(bottomBar)

        bottomBar.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(70.0)
        }
    }

    func setAddWritingButton() {
        view.addSubview(addWritingButton)
        addWritingButton.snp.makeConstraints {
            $0.size.equalTo(55.0)
            $0.right.equalToSuperview().offset(-20.0)
            $0.bottom.equalTo(bottomBar.snp.top).offset(-14.0)
        }
    }

    func bindView() {
        // Input
        enterButton.rx.tap
            .bind(to: viewModel.input.enterButtonTap)
            .disposed(by: disposeBag)

        addWritingButton.rx.tap
            .bind(to: viewModel.input.addWritingButtonTap)
            .disposed(by: disposeBag)

        bottomBar.participantButton.rx.tap
            .bind(to: viewModel.input.participantButtonTap)
            .disposed(by: disposeBag)

        // Output
        viewModel.output.goToRoom
            .withUnretained(self)
            .bind { owner, _ in
                owner.goToPopUpVC()
            }
            .disposed(by: disposeBag)

        viewModel.output.goToWriting
            .withUnretained(self)
            .bind {owner, articleList in
                owner.goToWritingVC(articleList: articleList)
            }
            .disposed(by: disposeBag)

        viewModel.output.goToParticipantView
            .withUnretained(self)
            .bind { owner, _ in
                owner.goToParticipationVC()
            }
            .disposed(by: disposeBag)

        viewModel.output.articleList
            .bind(to: detailView.relayWritingList.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func goToPopUpVC() {
        let vc = PopUpViewController()
        vc.viewModel.relay = viewModel.relayInfo
        vc.viewModel.output.relayDetailViewStyle
            .withUnretained(self)
            .bind { owner, style in
                if style == .nonParticipation {
                    owner.bottomBar.removeFromSuperview()
                    owner.setEnterButton()
                } else {
                    owner.enterButton.removeFromSuperview()
                    owner.setBottomBar()
                    owner.setAddWritingButton()
                }
            }
            .disposed(by: disposeBag)
        vc.modalPresentationStyle = .overFullScreen

        self.present(vc, animated: false)
    }

    private func goToWritingVC(articleList: [Article]) {
        let vc = RelayWritingViewController()
        vc.viewModel.articleList = articleList
        vc.viewModel.relayInfo = viewModel.relayInfo
        vc.modalPresentationStyle = .fullScreen

        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func goToParticipationVC() {
        let vc = ParticipantViewController()
        vc.modalPresentationStyle = .fullScreen

        self.present(vc, animated: false, completion: nil)
    }

}
