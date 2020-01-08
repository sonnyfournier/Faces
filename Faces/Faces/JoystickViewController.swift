//
//  ViewController.swift
//  Faces
//
//  Created by Sonny Fournier on 03/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit
import SnapKit

// Special thanks to DonMag
// https://stackoverflow.com/questions/59616783/move-a-circular-uiview-inside-another-circular-uiview

class JoystickViewController: UIViewController {

    var joystickSize: CGFloat = 150
    var substractSize: CGFloat = 200

    // If you want the "joystick" circle to overlap the "outer circle" a bit, adjust this value
    var offsetMultiplier: CGFloat = 0.5

    private var innerRadius: CGFloat = 0.0

    /// Mark - Views
    private let joystickSubstractView = UIView()
    private let joystickView = UIView()

    // TODO: Remove this - debug purpose
    let debugTextView = UITextView()
    let line = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        joystickSubstractView.backgroundColor = .gray
        joystickSubstractView.layer.cornerRadius = CGFloat(substractSize / 2)
        self.view.addSubview(joystickSubstractView)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragJoystick(_:)))
        joystickView.isUserInteractionEnabled = true
        joystickView.addGestureRecognizer(panGesture)
        joystickView.backgroundColor = .yellow
        joystickView.layer.cornerRadius = CGFloat(joystickSize / 2)
        joystickSubstractView.addSubview(joystickView)

        joystickSubstractView.snp.makeConstraints {
            $0.size.equalTo(substractSize)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
        }

        joystickView.snp.makeConstraints {
            $0.size.equalTo(joystickSize)
            $0.center.equalToSuperview()
        }

        // TODO: Remove this - debug purpose
        debugTextView.text = "✛"
        debugTextView.textAlignment = .center
        debugTextView.font = debugTextView.font?.withSize(20)
        self.view.addSubview(debugTextView)
        debugTextView.snp.makeConstraints {
            $0.width.equalTo(450)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()//.inset(150)
        }

        let tmp = UIView()
        tmp.backgroundColor = .red
        self.view.addSubview(tmp)
        tmp.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(substractSize)
            $0.center.equalTo(joystickSubstractView)
        }

        let separator1 = UIView()
        separator1.backgroundColor = .red
        self.view.addSubview(separator1)
        separator1.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(substractSize)
            $0.center.equalTo(joystickSubstractView)
        }

        let separator2 = UIView()
        separator2.backgroundColor = .red
        self.view.addSubview(separator2)
        separator2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(substractSize)
            $0.center.equalTo(joystickSubstractView)
        }
        // End of debug

        innerRadius = (substractSize - joystickSize) * offsetMultiplier
    }

    @objc private func dragJoystick(_ sender: UIPanGestureRecognizer) {
        let touchedLocation = sender.location(in: joystickSubstractView)

        let joystickSubstractViewCenter = CGPoint(x: joystickSubstractView.bounds.width / 2,
                                                  y: joystickSubstractView.bounds.height / 2)

        var newJoystickCenter = touchedLocation

        let distance = lineLength(from: touchedLocation, to: joystickSubstractViewCenter)

        // If the touch would put the joystick view outside the substract view
        // find the point on the line from center to touch, at innerRadius distance
        if distance > innerRadius {
            newJoystickCenter = pointOnLine(from: joystickSubstractViewCenter,
                                            to: touchedLocation, distance: innerRadius)
        }

        // TEST ZONE
        let linePath = UIBezierPath()
        let convertedSubstractCenter = joystickSubstractView.convert(joystickSubstractViewCenter, to: self.view)
        let convertedJoystickCenter = joystickSubstractView.convert(newJoystickCenter, to: self.view)
        linePath.move(to: convertedSubstractCenter)
        linePath.addLine(to: convertedJoystickCenter)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 1
        line.lineJoin = CAShapeLayerLineJoin.round
        line.removeFromSuperlayer()
        self.view.layer.addSublayer(line)

        let slope = (joystickSubstractViewCenter.y - newJoystickCenter.y) /
            (joystickSubstractViewCenter.x - newJoystickCenter.x)
        var tan = atan(slope)
        if newJoystickCenter.x > joystickSubstractViewCenter.x,
            newJoystickCenter.y > joystickSubstractViewCenter.y {
            // debugTextView.text = "⬊"
            tan = -tan
        } else if newJoystickCenter.x > joystickSubstractViewCenter.x,
                   newJoystickCenter.y < joystickSubstractViewCenter.y {
            // debugTextView.text = "⬈"
            tan = -tan
        } else if newJoystickCenter.x < joystickSubstractViewCenter.x,
            newJoystickCenter.y < joystickSubstractViewCenter.y {
            // debugTextView.text = "⬉"
        } else if newJoystickCenter.x < joystickSubstractViewCenter.x,
            newJoystickCenter.y > joystickSubstractViewCenter.y {
            // debugTextView.text = "⬋"
        }

        let oldRange: CGFloat = (CGFloat.pi / 2) + (CGFloat.pi / 2)
        let newRange: CGFloat = 1.0 - 0.0
        // Convert range from [-1.5, 1.5] to [0.0, 1.0]
        let tmp1 = tan + (CGFloat.pi / 2)
        let newTan = ((tmp1 * newRange) / oldRange)

        debugTextView.text = "Slope: \(newTan)"

        if newJoystickCenter.x >= joystickSubstractViewCenter.x,
            newJoystickCenter.y >= joystickSubstractViewCenter.y {
            if newTan >= 0, newTan < 1 / 8 {
                debugTextView.text = "Bottom"
            } else  if newTan <= 1 / 2, newTan > (1 / 8) * 3 {
                debugTextView.text = "Right"
            } else {
                debugTextView.text = "Bottom | Right"
            }
        } else if newJoystickCenter.x >= joystickSubstractViewCenter.x,
                   newJoystickCenter.y <= joystickSubstractViewCenter.y {
            if newTan >= 1 / 2, newTan < (1 / 8) * 5 {
                debugTextView.text = "Right"
            } else if newTan <= 1, newTan > (1 / 8) * 7 {
                debugTextView.text = "Top"
            } else {
                debugTextView.text = "Top | Right"
            }
        } else if newJoystickCenter.x <= joystickSubstractViewCenter.x,
            newJoystickCenter.y <= joystickSubstractViewCenter.y {
            if newTan >= 1 / 2, newTan < (1 / 8) * 5 {
                debugTextView.text = "Left"
            } else if newTan > (1 / 8) * 7, newTan <= 1 {
                debugTextView.text = "Top"
            } else {
                debugTextView.text = "Top | Left"
            }
        } else if newJoystickCenter.x <= joystickSubstractViewCenter.x,
            newJoystickCenter.y >= joystickSubstractViewCenter.y {
            if newTan <= 1 / 2, newTan > (1 / 8) * 3 {
                debugTextView.text = "Left"
            } else if newTan >= 0, newTan < (1 / 8) {
                debugTextView.text = "Bottom"
            } else {
                debugTextView.text = "Bottom | Left"
            }
        }
        // END TEST ZONE

        joystickView.center = newJoystickCenter
    }

    // TODO: Move those method in a helper (MathHelper maybe ?)
    private func lineLength(from firstPoint: CGPoint, to secondPoint: CGPoint) -> CGFloat {
        return hypot(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y)
    }

    private func pointOnLine(from startPoint: CGPoint, to endPoint: CGPoint, distance: CGFloat) -> CGPoint {
        let totalDistance = lineLength(from: startPoint, to: endPoint)
        let totalDelta = CGPoint(x: endPoint.x - startPoint.x, y: endPoint.y - startPoint.y)
        let percentage = distance / totalDistance
        let delta = CGPoint(x: totalDelta.x * percentage, y: totalDelta.y * percentage)
        return CGPoint(x: startPoint.x + delta.x, y: startPoint.y + delta.y)
    }
}
