//
//  MyWritingCell.swift
//  Kkamagnoon
//
//  Created by 서정 on 2022/02/23.
//

import UIKit
import Then

class MyWritingCell: UICollectionViewCell {

    static let identifier = "MyWritingCellIdentifier"
    var titleLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(weight: .semibold, size: 14)
            $0.textColor = .white
        }

    var statusLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(weight: .regular, size: 10)
            $0.text = "비공개"
            $0.textColor = UIColor(rgb: 0x9C9C9C)
        }

    var dotLabel = UILabel()
        .then {
            $0.text = StringType.dot
            $0.font = UIFont.pretendard(weight: .regular, size: 10)
            $0.textColor = UIColor(rgb: 0x626262)
        }

    var dateLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(weight: .regular, size: 10)
            $0.textColor = UIColor(rgb: 0x626262)
            $0.text = "2022년 2월 1일"
        }

    var contentLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(weight: .regular, size: 13)
            $0.numberOfLines = 5
            $0.textColor = UIColor(rgb: 0xEAEAEA)
            $0.setTextWithLineHeight(
                text: "거울은 나를 비춰주는 물건이다. 거울을 멍하니 바라보면 내가 누구인지 조금은 알 것 같은 기분이다.",
                lineHeight: .lineheightInBox)
        }

    var likeLabel = ImageLabelView()
        .then {
            $0.imageView.image = UIImage(named: "Heart")
        }

    var commentLabel = ImageLabelView()
        .then {
            $0.imageView.image = UIImage(named: "Comment")
        }

    var moreButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "More"), for: .normal)
        }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(rgb: 0x292929)
        self.layer.cornerRadius = 15
        setView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(rgb: 0x292929)
        self.layer.cornerRadius = 15
        setView()
    }
}

extension MyWritingCell {

    func setView() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28.0)
            $0.left.equalToSuperview().offset(20.0)
        }

        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview().offset(-20.0)
        }

        self.addSubview(dotLabel)
        dotLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalTo(dateLabel.snp.left).offset(-6.0)
        }

        self.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalTo(dotLabel.snp.left).offset(-6.0)
        }

        self.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.width.equalTo(UIScreen.main.bounds.width - 80)
            $0.right.equalToSuperview().offset(-20.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
        }

        self.addSubview(likeLabel)
        likeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20.0)
            $0.bottom.equalToSuperview().offset(-28.0)
            $0.top.equalTo(contentLabel.snp.bottom).offset(12.0)
        }

        self.addSubview(commentLabel)
        commentLabel.snp.makeConstraints {
            $0.left.equalTo(likeLabel.snp.right).offset(32.0)
            $0.centerY.equalTo(likeLabel)
        }

        self.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.size.equalTo(24.0)
            $0.right.equalToSuperview().offset(-20.0)
            $0.centerY.equalTo(likeLabel)
        }

    }
}
