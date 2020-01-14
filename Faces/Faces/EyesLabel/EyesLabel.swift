//
//  EyesLabel.swift
//  Faces
//
//  Created by Sonny Fournier on 14/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit

class EyesLabel: UILabel {
    //var viewModel: EyesViewModel

    var selected: Bool = false {
        didSet {
            self.textColor = selected ? .white : .gray
        }
    }
    var direction: JoystickDirection?

    init(text: String, direction: JoystickDirection) {
        // self.viewModel = viewModel
        super.init(frame: CGRect.zero)

        self.direction = direction

        self.text = text
        self.textColor = .gray
        self.font = UIFont.boldSystemFont(ofSize: 20)
        self.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
