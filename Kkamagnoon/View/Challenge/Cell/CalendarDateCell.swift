//
//  CalendarDateCell.swift
//  Kkamagnoon
//
//  Created by 서정 on 2022/02/20.
//
import UIKit
import SnapKit
import Then
import FSCalendar

class CalendarDateCell: FSCalendarCell {
    static let identifier = "CalendarDateCellIdentifier"

    var indicatorImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "Frame")
        }

    var selectorView = UIView()
        .then {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 8
        }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            configureSelected()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configureSelected()
    }

    func setView() {

        self.shapeLayer.frame = self.bounds

        let dateView = self.subviews.first ?? UIView()

        self.insertSubview(selectorView, at: 0)
        selectorView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(self.frame.height)
        }

        dateView.snp.makeConstraints {
            $0.height.equalTo(19)
            $0.top.equalToSuperview().offset(6.0)
            $0.left.right.equalToSuperview()
        }

        eventIndicator.subviews.first?.alpha = 0.0

        eventIndicator.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dateView.snp.bottom as! ConstraintRelatableTarget).offset(3)
        }

        eventIndicator.addSubview(indicatorImageView)

        indicatorImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(25)
        }

    }

    private func configureSelected() {

        if isSelected {
            self.selectorView.backgroundColor = UIColor(rgb: 0x515151)
        } else {
            self.selectorView.backgroundColor = .clear
        }
    }

}
