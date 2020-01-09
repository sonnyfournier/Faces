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
    let slopeTextView = UITextView()
    let line = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        setViewsConstraints()

        innerRadius = (substractSize - joystickSize) * offsetMultiplier

        // TODO: Remove this - debug purpose
        slopeTextView.font = slopeTextView.font?.withSize(20)
        self.view.addSubview(slopeTextView)
        slopeTextView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
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
    }

    private func initViews() {
        joystickSubstractView.backgroundColor = .gray
        joystickSubstractView.layer.cornerRadius = CGFloat(substractSize / 2)
        self.view.addSubview(joystickSubstractView)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragJoystick(_:)))
        joystickView.isUserInteractionEnabled = true
        joystickView.addGestureRecognizer(panGesture)
        joystickView.backgroundColor = .yellow
        joystickView.layer.cornerRadius = CGFloat(joystickSize / 2)
        joystickSubstractView.addSubview(joystickView)
    }

    private func setViewsConstraints() {
        joystickSubstractView.snp.makeConstraints {
            $0.size.equalTo(substractSize)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
        }

        joystickView.snp.makeConstraints {
            $0.size.equalTo(joystickSize)
            $0.center.equalToSuperview()
        }
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
        let convertedJoystickCenter = joystickSubstractView.convert(newJoystickCenter, to: self.view)
        linePath.move(to: joystickSubstractView.center)
        linePath.addLine(to: convertedJoystickCenter)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 1
        line.lineJoin = CAShapeLayerLineJoin.round
        line.removeFromSuperlayer()
        self.view.layer.addSublayer(line)

        let slope = (convertedJoystickCenter.y - joystickSubstractView.center.y) /
            -(convertedJoystickCenter.x - joystickSubstractView.center.x)
        let degrees = atan(slope) * 180 / CGFloat.pi
        slopeTextView.text = "Degrees: \(degrees)°"

        if convertedJoystickCenter.y > joystickSubstractView.center.y {
            slopeTextView.text = degrees > 0 ? "Top | Right" : "Top | Left"
        } else {
            slopeTextView.text = degrees > 0 ? "Bottom | Left" : "Bottom | Right"
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
