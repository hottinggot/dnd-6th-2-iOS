//
//  ChallengeViewController.swift
//  Kkamagnoon
//
//  Created by 서정 on 2022/02/06.
//
import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import FSCalendar

class ChallengeViewController: UIViewController {

    let viewModel = ChallengeViewModel()
    var disposeBag = DisposeBag()

    var isMonth: Bool = false

    let formatter = DateFormatter()
    var eventsArray = [Date]()
    var eventsArray_Done = [Date]()

    var scrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
        }

    var challengeMainView = ChallengeMainView()

    var addWritingButton = MakingRoomButton()
        .then {
            $0.setImage(UIImage(named: "Pencil"), for: .normal)
        }

    var headerView = ChallengeHeaderView()

    var nothingImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "NothingCharacter")
        }

    var nothingLabel = UILabel()
        .then {
            $0.text = "오늘은 아직 글을\n쓰지 않았어요!"
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = UIFont.pretendard(weight: .regular, size: 18)
            $0.textColor = UIColor(rgb: 0xF5F5F5)
        }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addWritingButton.layer.cornerRadius = addWritingButton.frame.size.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        view.backgroundColor = UIColor(rgb: Color.basicBackground)
        challengeMainView.calendarView.delegate = self
        challengeMainView.calendarView.dataSource = self

        formatter.dateFormat = "EEE MMM dd yyyy"
        setView()
        bindView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.bindKeyword()
        bindCardView()
    }

    func setView() {

        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.left.right.top.equalTo(view.safeAreaLayoutGuide)
        }

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(challengeMainView)
        challengeMainView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalToSuperview()
        }

        view.addSubview(addWritingButton)
        addWritingButton.snp.makeConstraints {
            $0.size.equalTo(55.0)
            $0.right.equalToSuperview().offset(-20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-14.0)
        }

    }

    func bindView() {
        // Input
        headerView.bellButton.rx.tap
            .bind(to: viewModel.input.bellButtonTap)
            .disposed(by: disposeBag)

        addWritingButton.rx.tap
            .bind(to: viewModel.input.addWritingButtonTap)
            .disposed(by: disposeBag)

        challengeMainView.expansionButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.setCalendarState()
            }
            .disposed(by: disposeBag)

        // Output
        viewModel.output.goToBellNotice
            .withUnretained(self)
            .bind { owner, _ in
                owner.goToBellNoticeVC()
            }
            .disposed(by: disposeBag)

        viewModel.output.goToWriting
            .withUnretained(self)
            .bind { owner, _ in
                owner.goToWritingVC()
            }
            .disposed(by: disposeBag)

        viewModel.output.goToDetail
            .withUnretained(self)
            .bind { owner, _ in
                owner.goToDetail()
            }
            .disposed(by: disposeBag)

        viewModel.output.keyWord
            .withUnretained(self)
            .bind { owner, challenge in
                owner.challengeMainView.todayKeyWordView
                    .keywordLabel.text = challenge.keyword?.content

                var stamp = 1

                // TODO: stamp 갯수 채우기
                owner.challengeMainView.subTitleLabel[0].text = "이번달은 \(stamp)개의 스탬프를 찍었어요!"

                let history = challenge.challengeHistory ?? []

                history.forEach({ date in
                    print(date)
                    if let date = self.formatter.date(from: date) {
                        self.eventsArray.append(date)
                    }

                })

                let articles = challenge.articles ?? []

                if articles.count == 0 {
                    owner.setImageCaseNothing()
                } else {
                    owner.challengeMainView.removeCard()

                    articles.forEach({ article in
                        let card = MyChallengeCard()
                        card.titleLabel.text = article.title
                        card.contentLabel.text = article.content
                        card.likeLabel.labelView.text = "\(article.likeNum ?? 0)"
                        card.commentLabel.labelView.text = "\(article.commentNum ?? 0)"

                        self.challengeMainView.stackView.addArrangedSubview(card)
                    })
                }
            }
            .disposed(by: disposeBag)
    }

    func bindCardView() {
        challengeMainView.stackView.subviews.forEach({ article in
            let card = article as! MyChallengeCard
            print(">>>>>>>Card: \(card.titleLabel.text)")

            card.tapHandler = {
                print("TAPPED!!")
            }
        })
    }

    private func goToBellNoticeVC() {
        let vc = BellNoticeViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func setImageCaseNothing() {
        challengeMainView.subTitleLabel[1].isHidden = true
        view.addSubview(nothingImageView)
        nothingImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(challengeMainView.todayKeyWordView.snp.bottom).offset(30.51)
            $0.width.equalTo(122)
            $0.height.equalTo(110)
        }

        view.addSubview(nothingLabel)
        nothingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nothingImageView.snp.bottom).offset(9)
        }
    }

    private func goToWritingVC() {
        let vc = WritingViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.hidesBottomBarWhenPushed = true
        vc.viewModel.rootView = self

        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func setCalendarState() {
        if isMonth {
            isMonth = false
            challengeMainView.calendarView.setScope(.week, animated: true)
            UIView.animate(withDuration: 10.0, delay: 0) {
                self.challengeMainView.calendarHeight.constant = 144
            }
        } else {
            isMonth = true
            challengeMainView.calendarView.setScope(.month, animated: true)
            UIView.animate(withDuration: 10.0, delay: 0) {
                self.challengeMainView.calendarHeight.constant = 400

            }

        }
    }

    private func goToDetail() {
        let vc = DetailContentViewController()
        vc.modalPresentationStyle = .fullScreen

        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ChallengeViewController: FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar,
                  boundingRectWillChange bounds: CGRect,
                  animated: Bool) {

        challengeMainView.calendarHeight.constant = 144

        self.view.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        if self.eventsArray.contains(date) {
            return 1

        }
        if self.eventsArray_Done.contains(date) {
            return 1

        }
        return 0

    }

}

// extension ChallengeViewController: FSCalendarDelegate {
//
//    // 날짜 선택 시 콜백 메소드
//    func calendar(_ calendar: FSCalendar,
//                  didSelect date: Date,
//                  at monthPosition: FSCalendarMonthPosition) {
//
//        print(formatter.string(from: date) + " 선택됨")
//    }
//    // 날짜 선택 해제 시 콜백 메소드
//    public func calendar(_ calendar: FSCalendar,
//                         didDeselect date: Date,
//                         at monthPosition: FSCalendarMonthPosition) {
//        eventsArray = []
//        print(formatter.string(from: date) + " 해제됨")
//
//    }
//
// }

extension ChallengeViewController: FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {

        let cell = calendar.dequeueReusableCell(withIdentifier: CalendarDateCell.identifier, for: date, at: position)

        return cell
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }

}
