//
//  JoystickView.swift
//  Faces
//
//  Created by Sonny Fournier on 12/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit
import SnapKit

// Special thanks to DonMag
// https://stackoverflow.com/questions/59616783/move-a-circular-uiview-inside-another-circular-uiview

class JoystickView: UIView {

    var viewModel: JoystickViewModel

    var joystickSize: CGFloat = 150
    var substractSize: CGFloat = 200

    // If you want the "joystick" circle to overlap the "outer circle" a bit, adjust this value
    var offsetMultiplier: CGFloat = 0.5

    var joystickColor: UIColor = .systemBackground
    var substractColor: UIColor = .gray

    private var innerRadius: CGFloat = 0.0

    /// Mark - Views
    private let substractView = UIView()
    private let joystickView = UIView()
    private var eyesLabels: [EyesLabel] = []

    // TODO: Move this
    private let eyesTexts = ["↖️", "⬆️", "↗️", "➡️", "↘️", "⬇️", "↙️", "⬅️"]

    init(viewModel: JoystickViewModel) {
        self.viewModel = viewModel

        super.init(frame: CGRect())

        initViews()
        setViewsConstraints()

        innerRadius = (substractSize - joystickSize) * offsetMultiplier
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initViews() {
        substractView.backgroundColor = substractColor
        substractView.layer.cornerRadius = CGFloat(substractSize / 2)
        self.addSubview(substractView)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragJoystick(_:)))
        joystickView.isUserInteractionEnabled = true
        joystickView.addGestureRecognizer(panGesture)
        joystickView.backgroundColor = joystickColor
        joystickView.layer.cornerRadius = CGFloat(joystickSize / 2)
        substractView.addSubview(joystickView)

        eyesLabels = JoystickDirection.allCases.enumerated().map({ index, direction in
            let eyesLabel = EyesLabel(text: eyesTexts[index], direction: direction)
            eyesLabel.layer.backgroundColor = UIColor.yellow.cgColor
            eyesLabel.layer.cornerRadius = 35 / 2
            self.addSubview(eyesLabel)
            return eyesLabel
        })
    }

    private func setViewsConstraints() {
        substractView.snp.makeConstraints {
            $0.size.equalTo(substractSize)
            $0.center.equalToSuperview()
        }

        joystickView.snp.makeConstraints {
            $0.size.equalTo(joystickSize)
            $0.center.equalToSuperview()
        }

        for eyesLabel in eyesLabels {
            eyesLabel.snp.makeConstraints {
                $0.size.equalTo(35)
                $0.centerY.equalTo(substractView).offset(viewModel.getVerticalOffset(for: eyesLabel.direction,
                                                                                     radius: substractSize / 2))
                $0.centerX.equalTo(substractView).offset(viewModel.getHorizontalOffset(for: eyesLabel.direction,
                                                                                       radius: substractSize / 2))
            }
        }
    }

    @objc private func dragJoystick(_ sender: UIPanGestureRecognizer) {
        joystickView.center = viewModel.dragJoystick(touchedLocation: sender.location(in: substractView),
                                                     joystickView: joystickView,
                                                     substractView: substractView,
                                                     innerRadius: innerRadius)
    }
}
