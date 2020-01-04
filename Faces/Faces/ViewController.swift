//
//  ViewController.swift
//  Faces
//
//  Created by Sonny Fournier on 03/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let joystickSize = 150
    let substractSize = 200
    let joystickOffset = 10

    let joystickSubstractView = UIView()
    let joystickView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        joystickSubstractView.backgroundColor = .gray
        joystickSubstractView.layer.cornerRadius = CGFloat(substractSize / 2)
        self.view.addSubview(joystickSubstractView)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragJoystick))
        joystickView.isUserInteractionEnabled = true
        joystickView.addGestureRecognizer(panGesture)
        joystickView.backgroundColor = .white
        joystickView.layer.cornerRadius = CGFloat(joystickSize / 2)
        joystickSubstractView.addSubview(joystickView)

        joystickSubstractView.snp.makeConstraints {
            $0.width.height.equalTo(substractSize)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
        }

        joystickView.snp.makeConstraints {
            $0.width.height.equalTo(joystickSize)
            $0.center.equalToSuperview()
        }
    }

    @objc func dragJoystick(_ sender: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(joystickView)
        let translation = sender.translation(in: self.view)

        let joystickCenter = joystickView.convert(joystickView.center, to: self.view)
        let futureJoystickCenter =  CGPoint(x: joystickCenter.x - joystickView.frame.minX + translation.x,
                                            y: joystickCenter.y - joystickView.frame.minY + translation.y)
        let distanceBetweenCenters = hypot(futureJoystickCenter.x - joystickSubstractView.center.x,
                                           futureJoystickCenter.y - joystickSubstractView.center.y)

        if CGFloat(substractSize / 2 + joystickOffset) >= (distanceBetweenCenters + CGFloat(joystickSize / 2)) {
            joystickView.center = CGPoint(x: joystickView.center.x + translation.x,
                                          y: joystickView.center.y + translation.y)
        }

        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}
