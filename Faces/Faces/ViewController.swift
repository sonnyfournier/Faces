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

    let joystickSize = 100
    let substractSize = 200

    let joystickSubstractView = UIView()
    let joystickView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        joystickSubstractView.backgroundColor = .yellow
        joystickSubstractView.layer.cornerRadius = CGFloat(substractSize / 2)
        self.view.addSubview(joystickSubstractView)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragJoystick))
        joystickView.isUserInteractionEnabled = true
        joystickView.addGestureRecognizer(panGesture)
        joystickView.backgroundColor = .red
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

        joystickView.center = CGPoint(x: joystickView.center.x + translation.x,
                                      y: joystickView.center.y + translation.y)

        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let substractCenter = scrollView.center
        let joystickCenter = joystickView.convert(joystickView.center, to: self.view)
        let distanceBetweenCenters = hypot((joystickCenter.x - joystickView.frame.minX) - substractCenter.x,
                                           (joystickCenter.y - joystickView.frame.minY) - substractCenter.y)

        if CGFloat(substractSize / 2) >= (distanceBetweenCenters + CGFloat(joystickSize / 2)) {
            print("Inside")
        } else {
            _ = CGPoint(x: substractCenter.x + ((joystickCenter.x - joystickView.frame.minX) - substractCenter.x),
                        y: substractCenter.y + ((joystickCenter.y - joystickView.frame.minY) - substractCenter.y))
        }
    }
}
