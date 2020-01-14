//
//  JoystickViewModel.swift
//  Faces
//
//  Created by Sonny Fournier on 12/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit

enum JoystickDirection: Int, CaseIterable {
    case topLeft
    case top
    case topRight
    case right
    case bottomRight
    case bottom
    case bottomLeft
    case left

    var angle: CGFloat {
        switch self {
        case .topLeft, .topRight, .bottomRight, .bottomLeft:
            return 45
        case .top, .bottom:
            return 90
        case .right, .left:
            return 0
        }
    }

    var coordinate: CGPoint {
        switch self {
        case .topLeft:
            return CGPoint(x: -1, y: 1)
        case .top:
            return CGPoint(x: 0, y: 1)
        case .topRight:
            return CGPoint(x: 1, y: 1)
        case .right:
            return CGPoint(x: 1, y: 0)
        case .bottomRight:
            return CGPoint(x: 1, y: -1)
        case .bottom:
            return CGPoint(x: 0, y: -1)
        case .bottomLeft:
            return CGPoint(x: -1, y: -1)
        case .left:
            return CGPoint(x: -1, y: 0)
        }
    }
}

class JoystickViewModel {
    func dragJoystick(touchedLocation: CGPoint, joystickView: UIView, substractView: UIView,
                      innerRadius: CGFloat) -> CGPoint {

        let joystickSubstractViewCenter = CGPoint(x: substractView.bounds.width / 2,
                                                  y: substractView.bounds.height / 2)

        var newJoystickCenter = touchedLocation

        let distance = lineLength(from: touchedLocation, to: joystickSubstractViewCenter)

        // If the touch would put the joystick view outside the substract view
        // find the point on the line from center to touch, at innerRadius distance
        if distance > innerRadius {
            newJoystickCenter = pointOnLine(from: joystickSubstractViewCenter,
                                            to: touchedLocation, distance: innerRadius)
        }

        let convertedJoystickCenter = substractView.convert(newJoystickCenter, to: substractView)
        let slope = (convertedJoystickCenter.y - substractView.center.y) / -(convertedJoystickCenter.x - substractView.center.x)
        let degrees = atan(slope) * 180 / CGFloat.pi
        let orientation = getJoystickDirection(joystickCenter: convertedJoystickCenter,
                                               substractCenter: substractView.center, degrees: degrees)

        print("Joystick's \(orientation)")
        return newJoystickCenter
    }

    private func getJoystickDirection(joystickCenter: CGPoint, substractCenter: CGPoint,
                                      degrees: CGFloat) -> JoystickDirection {
        // If we check that the location of the joystick y is lower than the location of
        // the substrat y rather than the other way around it is because on iOS the coordinates (0, 0)
        // are located at the top left of the screen.
        // So if the location of the joystick y is lower than the location of the substract y
        // it actually means that joystick center is above substract center
        let joystickIsUp: Bool = joystickCenter.y < substractCenter.y
        if abs(degrees) >= 0, abs(degrees) <= 90 / 4 {
            return joystickIsUp ? (degrees > 0 ? JoystickDirection.right : JoystickDirection.left) :
                (degrees > 0 ? JoystickDirection.left : JoystickDirection.right)
        } else if abs(degrees) >= 90 / 4, abs(degrees) <= (90 / 4) * 3 {
            return joystickIsUp ? (degrees > 0 ? JoystickDirection.topRight : JoystickDirection.topLeft) :
                (degrees > 0 ? JoystickDirection.bottomLeft :  JoystickDirection.bottomRight)
        } else {
            return joystickIsUp ? JoystickDirection.top : JoystickDirection.bottom
        }
    }

    func getVerticalOffset(for direction: JoystickDirection?, radius: CGFloat) -> CGFloat {
        guard let direction = direction else { return 0 }

        let offset: CGFloat = 30
        return (radius + offset) * sin(direction.angle.toRadians()) * direction.coordinate.y * -1
    }

    func getHorizontalOffset(for direction: JoystickDirection?, radius: CGFloat) -> CGFloat {
        guard let direction = direction else { return 0 }

        let offset: CGFloat = 30
        return (radius + offset) * cos(direction.angle.toRadians()) * direction.coordinate.x
    }
}
