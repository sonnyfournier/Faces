//
//  GeometryHelper.swift
//  Faces
//
//  Created by Sonny Fournier on 12/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit

func lineLength(from firstPoint: CGPoint, to secondPoint: CGPoint) -> CGFloat {
    return hypot(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y)
}

func pointOnLine(from startPoint: CGPoint, to endPoint: CGPoint, distance: CGFloat) -> CGPoint {
    let totalDistance = lineLength(from: startPoint, to: endPoint)
    let totalDelta = CGPoint(x: endPoint.x - startPoint.x, y: endPoint.y - startPoint.y)
    let percentage = distance / totalDistance
    let delta = CGPoint(x: totalDelta.x * percentage, y: totalDelta.y * percentage)
    return CGPoint(x: startPoint.x + delta.x, y: startPoint.y + delta.y)
}
