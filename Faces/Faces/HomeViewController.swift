//
//  HomeViewController.swift
//  Faces
//
//  Created by Sonny Fournier on 03/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private var joystickView: JoystickView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let joystickViewModel = JoystickViewModel()
        joystickView = JoystickView(viewModel: joystickViewModel)
        joystickView.joystickSize = 150
        joystickView.substractSize = 200
        joystickView.offsetMultiplier = 0.7
        self.view.addSubview(joystickView)
        joystickView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(200)
        }
    }
}
