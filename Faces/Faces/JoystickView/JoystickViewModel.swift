//
//  JoystickViewModel.swift
//  Faces
//
//  Created by Sonny Fournier on 12/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit

enum JoystickOrientation {
    case topLeft
    case top
    case topRight
    case right
    case bottomRight
    case bottom
    case bottomLeft
    case left
    case none
}

class JoystickViewModel {
    func dragJoystick(touchedLocation: CGPoint, joystickView: UIView, joystickSubstractView: UIView,
                      innerRadius: CGFloat) -> CGPoint {

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

        let convertedJoystickCenter = joystickSubstractView.convert(newJoystickCenter, to: joystickSubstractView)
        let slope = (convertedJoystickCenter.y - joystickSubstractView.center.y) /
            -(convertedJoystickCenter.x - joystickSubstractView.center.x)
        let degrees = atan(slope) * 180 / CGFloat.pi
        let orientation = getJoystickOrientation(joystickCenter: convertedJoystickCenter,
                                                 substractCenter: joystickSubstractView.center, degrees: degrees)

        print("Joystick's \(orientation)")
        return newJoystickCenter
    }

    private func getJoystickOrientation(joystickCenter: CGPoint, substractCenter: CGPoint,
                                        degrees: CGFloat) -> JoystickOrientation {
        // If we check that the location of the joystick y is lower than the location of
        // the substrat y rather than the other way around it is because on iOS the coordinates (0, 0)
        // are located at the top left of the screen.
        // So if the location of the joystick y is lower than the location of the substract y
        // it actually means that joystick center is above substract center
        let joystickIsUp: Bool = joystickCenter.y < substractCenter.y
        if abs(degrees) >= 0, abs(degrees) <= 90 / 4 {
            return joystickIsUp ? (degrees > 0 ? JoystickOrientation.right : JoystickOrientation.left) :
                (degrees > 0 ? JoystickOrientation.left : JoystickOrientation.right)
        } else if abs(degrees) >= 90 / 4, abs(degrees) <= (90 / 4) * 3 {
            return joystickIsUp ? (degrees > 0 ? JoystickOrientation.topRight : JoystickOrientation.topLeft) :
                (degrees > 0 ? JoystickOrientation.bottomLeft :  JoystickOrientation.bottomRight)
        } else {
            return joystickIsUp ? JoystickOrientation.top : JoystickOrientation.bottom
        }
    }
}
