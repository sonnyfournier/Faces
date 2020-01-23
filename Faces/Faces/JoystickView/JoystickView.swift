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
    var containerSize: CGFloat = 200

    /// If you want the "joystick" circle to overlap the container circle, adjust this value
    var offsetMultiplier: CGFloat = 0.5

    var joystickColor: UIColor = .systemBackground
    var containerColor: UIColor = .gray

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

    private let containerView = UIView()
    private let joystickView = UIView()
    private var joystickRelatedEyesLabels: [EyesLabel] = []

    // MARK: - Initialization

    init(viewModel: JoystickViewModel) {

        self.viewModel = viewModel

        super.init(frame: CGRect())

        setupViews()
        setupViewsConstraints()

        innerRadius = (containerSize - joystickSize) * offsetMultiplier
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Views setup

    private func setupViews() {

        containerView.backgroundColor = containerColor
        containerView.layer.cornerRadius = CGFloat(containerSize / 2)
        self.addSubview(containerView)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragJoystick(_:)))
        joystickView.isUserInteractionEnabled = true
        joystickView.addGestureRecognizer(panGesture)
        joystickView.backgroundColor = joystickColor
        joystickView.layer.cornerRadius = CGFloat(joystickSize / 2)
        containerView.addSubview(joystickView)

        joystickRelatedEyesLabels = Position.allCases.enumerated().map({ index, position in
            let eyesLabelViewModel = EyesLabelViewModel(text: eyesTexts[index], position: position)
            let eyesLabel = EyesLabel(viewModel: eyesLabelViewModel)
            self.addSubview(eyesLabel)
            return eyesLabel
        })
    }

    private func setupViewsConstraints() {

        containerView.snp.makeConstraints {
            $0.size.equalTo(containerSize)
            $0.center.equalToSuperview()
        }

        joystickView.snp.makeConstraints {
            $0.size.equalTo(joystickSize)
            $0.center.equalToSuperview()
        }

        for eyesLabel in joystickRelatedEyesLabels {
            let radius = containerSize / 2
            let margin: CGFloat = 30
            let offset = viewModel.getOffset(for: eyesLabel.position, inCircleOf: radius, with: margin)
            eyesLabel.snp.makeConstraints {
                $0.size.equalTo(35)
                $0.centerY.equalTo(containerView).offset(offset.vertical)
                $0.centerX.equalTo(containerView).offset(offset.horizontal)
            }
        }
    }

    // MARK: - Actions

    @objc private func dragJoystick(_ sender: UIPanGestureRecognizer) {

        joystickCenter = viewModel.getNewJoystickCenter(from: sender.location(in: containerView),
                                                               in: containerView.bounds, with: innerRadius)
    }

    // MARK: - Functions

    func getJoystickDirection() -> JoystickDirection? {

        guard let joystickCenter = joystickCenter else { return nil }

        let convertedJoystickCenter = containerView.convert(joystickCenter, to: containerView)
        return viewModel.getJoystickDirectionFromSlope(between: convertedJoystickCenter, and: containerView.center)
    }

    func selectEyesLabelAccording(to direction: JoystickDirection?) {

        guard let direction = direction else { return }

        for eyesLabel in joystickRelatedEyesLabels {
            eyesLabel.selected = eyesLabel.position == direction
        }
    }
}
