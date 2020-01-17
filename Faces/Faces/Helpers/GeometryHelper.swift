//
//  GeometryHelper.swift
//  Faces
//
//  Created by Sonny Fournier on 12/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit

/// Calculates the length of a line
/// - Parameters:
///   - firstPoint: The starting point of the line
///   - secondPoint: The ending point of the line
/// - Returns: The length of the line
func lineLength(from firstPoint: CGPoint, to secondPoint: CGPoint) -> CGFloat {

    return hypot(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y)
}

/// Find the point on the line from `startPoint` to `endPoint`, at specified `distance`
/// - Parameters:
///   - startPoint: The starting point of the line
///   - endPoint: The ending point of the line
///   - distance: distance
/// - Returns: The point on the line at distance
func pointOnLine(from startPoint: CGPoint, to endPoint: CGPoint, distance: CGFloat) -> CGPoint {

    let totalDistance = lineLength(from: startPoint, to: endPoint)
    let totalDelta = CGPoint(x: endPoint.x - startPoint.x, y: endPoint.y - startPoint.y)
    let percentage = distance / totalDistance
    let delta = CGPoint(x: totalDelta.x * percentage, y: totalDelta.y * percentage)
    return CGPoint(x: startPoint.x + delta.x, y: startPoint.y + delta.y)
}
