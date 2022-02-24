//
//  MakingRelayRoomViewModel.swift
//  Kkamagnoon
//
//  Created by 서정 on 2022/02/18.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class MakingRelayRoomModel: ViewModelType {

    var disposeBag = DisposeBag()
    var rootView: UIViewController?

    struct Input {

        let addingTagButtonTap = PublishSubject<String>()
        let originalTagList = PublishSubject<[String]>()

        let title = PublishSubject<String>()
        let notice = PublishSubject<String>()

        let plusButtonTap = PublishSubject<Void>()
        let minusButtonTap = PublishSubject<Void>()

        let startButtonTap = PublishSubject<Void>()

    }

    struct Output {
        let tagList = PublishRelay<[SectionModel<String, String>]>()

        let goToSelectTag = PublishRelay<Void>()

        let enableStartButton = PublishRelay<Bool>()
        let goToNewRelay = PublishRelay<Void>()

        let personnelCount = BehaviorRelay<Int>(value: 0)
    }

    var input: Input
    var output: Output

    init(input: Input = Input(),
         output: Output = Output()) {
        self.input = input
        self.output = output
        bindAddingTag()
        bindOriginalTagList()
        bindStartButtonEnable()
        bindStartButtonTap()
    }

    func bindTagList() {
        output.tagList.accept(
            [SectionModel(model: "", items: [StringType.addTagString])]
        )
    }

    func bindOriginalTagList() {
        input.originalTagList
            .withUnretained(self)
            .bind { owner, tagArray in
                var newArray = tagArray
                newArray.append(StringType.addTagString)
                owner.output.tagList.accept(
                    [SectionModel(model: "", items: newArray)]
                )
            }
            .disposed(by: disposeBag)
    }

    func bindStartButtonEnable() {
        Observable.combineLatest(input.title, input.notice)
            .map { title, notice in
                if title == StringType.titlePlaceeholder ||
                    notice == StringType.noticePlaceholder {
                    return false
                }
                return true
            }
            .bind(to: output.enableStartButton)
            .disposed(by: disposeBag)

    }

    func bindStartButtonTap() {
        input.startButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                owner.output.goToNewRelay.accept(())
            }
            .disposed(by: disposeBag)
    }

    func bindPersonnel() {
        input.minusButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                print(">>> TAP")
                if owner.output.personnelCount.value > 0 {
                    owner.output.personnelCount.accept(owner.output.personnelCount.value-1)
                }
            }
            .disposed(by: disposeBag)

        input.plusButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                if owner.output.personnelCount.value < 10 {
                    owner.output.personnelCount.accept(owner.output.personnelCount.value+1)
                }
            }
            .disposed(by: disposeBag)
    }

    func bindAddingTag() {
        input.addingTagButtonTap
            .withUnretained(self)
            .bind { owner, model in
                if model == "태그 추가" {
                    owner.output.goToSelectTag.accept(())
                }
            }
            .disposed(by: disposeBag)
    }

}