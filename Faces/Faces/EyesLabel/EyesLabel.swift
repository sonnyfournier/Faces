//
//  EyesLabel.swift
//  Faces
//
//  Created by Sonny Fournier on 14/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit

typealias Position = JoystickDirection

extension Position {

    /// Angle (in absolute value) between the abscissa reference mark and
    /// the segment connecting the origin of the reference mark to the position coordinates (self.coordinate).
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

    /// Theoretical coordinates of the position on an orthonormal
    /// coordinate system with coordinates between (-1, -1) and (1, 1).
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

class EyesLabel: UILabel {

    //var viewModel: EyesViewModel

    // MARK: Properties

    var selected: Bool = false {
        didSet {
            self.textColor = selected ? .white : .gray
        }
    }
    var position: Position?

    // MARK: - Initialization

    init(text: String, position: Position) {

        // self.viewModel = viewModel
        super.init(frame: CGRect.zero)

        self.position = position

        self.text = text
        self.textColor = .gray
        self.font = UIFont.boldSystemFont(ofSize: 20)
        self.textAlignment = .center
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}
