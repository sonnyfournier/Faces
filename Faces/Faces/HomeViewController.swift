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

    // MARK: - Views

    private var joystickView: JoystickView!

    // MARK: - Life cycle

    override func viewDidLoad() {

        super.viewDidLoad()

        setupViews()
        setupViewsConstraints()
    }

    // MARK: - Views setup

    func setupViews() {

        let joystickViewModel = JoystickViewModel()
        joystickView = JoystickView(viewModel: joystickViewModel)
        joystickView.joystickSize = 150
        joystickView.substractSize = 200
        joystickView.offsetMultiplier = 0.7
        self.view.addSubview(joystickView)
    }

    func setupViewsConstraints() {

        joystickView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(200)
        }
    }
}
