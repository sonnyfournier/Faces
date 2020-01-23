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
}

class JoystickViewModel {

    func getNewJoystickCenter(from touchedLocation: CGPoint, in bounds: CGRect, with innerRadius: CGFloat) -> CGPoint {

        let containerViewCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        var newJoystickCenter = touchedLocation

        let distance = lineLength(from: touchedLocation, to: containerViewCenter)

        // If the touch would put the joystick view outside the container view
        // find the point on the line from center to touch, at innerRadius distance
        if distance > innerRadius {
            newJoystickCenter = pointOnLine(from: containerViewCenter, to: touchedLocation, distance: innerRadius)
        }

        return newJoystickCenter
    }

    func getJoystickDirectionFromSlope(between joystickCenter: CGPoint,
                                       and containerCenter: CGPoint) -> JoystickDirection {

        let slope = (joystickCenter.y - containerCenter.y) / -(joystickCenter.x - containerCenter.x)
        let degrees = atan(slope) * 180 / CGFloat.pi

        // If we check that the location of the joystick y is lower than the location of
        // the substrat y rather than the other way around it is because on iOS the coordinates (0, 0)
        // are located at the top left of the screen.
        // So if the location of the joystick y is lower than the location of the container y
        // it actually means that joystick center is above container center.
        let joystickIsUp: Bool = joystickCenter.y < containerCenter.y

        // The angle between the slope and the x-axis can be used
        // to determine in which quarter the joystick is located.
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

    // To place the views in a circle around the joystick
    // they must all be at equal distance from the center of the joystick.
    //
    // If we applied the same distance between the center of the views
    // and the center of the joystick, the views would be placed in a square. (see diagram 1.1)
    //
    // In order to compensate for this, containerView is considered to be a trigonometric circle.
    // Then, we will be able to project the desired point (located at a `radius' distance from the center of the circle)
    // in order to obtain its x and y coordinates. (see diagram 1.2)
    // x = radius * cos(angle)
    // y = radius * sin(angle)
    func getOffset(for position: Position?, inCircleOf radius: CGFloat,
                   with margin: CGFloat) -> (horizontal: CGFloat, vertical: CGFloat) {

        guard let position = position else { return (0, 0) }

        // The coordinates obtained are multiplied by the coordinates of the position
        // (which can be equal to -1, 0 or 1) in order to recover negative coordinates
        // for x in case of "lefties" direction and for y in case of "bottoms" one.
        let xCoordinate = (radius + margin) * cos(position.angle.toRadians()) * position.coordinate.x

        // Here, we multiply by -1 because on iOS the coordinates (0, 0) of the screen
        // are located at the top left of the screen. So we invert the y coordinates
        // in order to find a "top" and a "bottom" that make sense.
        let yCoordinate = (radius + margin) * sin(position.angle.toRadians()) * position.coordinate.y * -1

        return (horizontal: xCoordinate, vertical: yCoordinate)
    }
}
