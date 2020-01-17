//
//  JoystickView.swift
//  Faces
//
//  Created by Sonny Fournier on 12/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit
import SnapKit

class JoystickView: UIView {

    private var viewModel: JoystickViewModel

    // MARK: - Properties

    var joystickSize: CGFloat = 150
    var substractSize: CGFloat = 200

    /// If you want the "joystick" circle to overlap the "substract" circle, adjust this value
    var offsetMultiplier: CGFloat = 0.5

    var joystickColor: UIColor = .systemBackground
    var substractColor: UIColor = .gray

    // MARK: - Private properties

    private var innerRadius: CGFloat = 0.0
    private var joystickCenter: CGPoint? {
        didSet {
            guard let joystickCenter = joystickCenter else { return }

            joystickView.center = joystickCenter
            let direction = getJoystickDirection()
            selectEyesLabelAccording(to: direction)
        }
    }
    // TODO: Maybe find a better place for this ?
    private let eyesTexts = ["^~", "^^", "~^", ">>", "⌐⌐", "><", "¬¬", "<<"]

    // MARK: - Views

    private let substractView = UIView()
    private let joystickView = UIView()
    private var joystickRelatedEyesLabels: [EyesLabel] = []

    // MARK: - Initialization

    init(viewModel: JoystickViewModel) {

        self.viewModel = viewModel

        super.init(frame: CGRect())

        setupViews()
        setupViewsConstraints()

        innerRadius = (substractSize - joystickSize) * offsetMultiplier
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Views setup

    private func setupViews() {

        substractView.backgroundColor = substractColor
        substractView.layer.cornerRadius = CGFloat(substractSize / 2)
        self.addSubview(substractView)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragJoystick(_:)))
        joystickView.isUserInteractionEnabled = true
        joystickView.addGestureRecognizer(panGesture)
        joystickView.backgroundColor = joystickColor
        joystickView.layer.cornerRadius = CGFloat(joystickSize / 2)
        substractView.addSubview(joystickView)

        joystickRelatedEyesLabels = Position.allCases.enumerated().map({ index, position in
            let eyesLabel = EyesLabel(text: eyesTexts[index], position: position)
            self.addSubview(eyesLabel)
            return eyesLabel
        })
    }

    private func setupViewsConstraints() {

        substractView.snp.makeConstraints {
            $0.size.equalTo(substractSize)
            $0.center.equalToSuperview()
        }

        joystickView.snp.makeConstraints {
            $0.size.equalTo(joystickSize)
            $0.center.equalToSuperview()
        }

        for eyesLabel in joystickRelatedEyesLabels {
            let radius = substractSize / 2
            let margin: CGFloat = 30
            let offset = viewModel.getOffset(for: eyesLabel.position, inCircleOf: radius, with: margin)
            eyesLabel.snp.makeConstraints {
                $0.size.equalTo(35)
                $0.centerY.equalTo(substractView).offset(offset.vertical)
                $0.centerX.equalTo(substractView).offset(offset.horizontal)
            }
        }
    }

    // MARK: - Actions

    @objc private func dragJoystick(_ sender: UIPanGestureRecognizer) {

        joystickCenter = viewModel.getNewJoystickCenter(from: sender.location(in: substractView),
                                                               in: substractView.bounds, with: innerRadius)
    }

    // MARK: - Functions

    func getJoystickDirection() -> JoystickDirection? {

        guard let joystickCenter = joystickCenter else { return nil }

        let convertedJoystickCenter = substractView.convert(joystickCenter, to: substractView)
        return viewModel.getJoystickDirectionFromSlope(between: convertedJoystickCenter, and: substractView.center)
    }

    func selectEyesLabelAccording(to direction: JoystickDirection?) {

        guard let direction = direction else { return }

        for eyesLabel in joystickRelatedEyesLabels {
            eyesLabel.selected = eyesLabel.position == direction
        }
    }
}
