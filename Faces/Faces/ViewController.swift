//
//  ViewController.swift
//  Faces
//
//  Created by Sonny Fournier on 03/01/2020.
//  Copyright © 2020 Sonny Fournier. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let joystickSize = 100
    let substractSize = 200

    let scrollView = UIScrollView()
    let joystickSubstractView = UIView()
    let joystickView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.backgroundColor = .blue
        scrollView.bounces = false
        scrollView.clipsToBounds = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = CGFloat(substractSize / 2)
        view.addSubview(scrollView)

        joystickSubstractView.backgroundColor = .yellow
        // joystickSubstractView.layer.cornerRadius = CGFloat(((substractSize - joystickSize) + substractSize) / 2)
        scrollView.addSubview(joystickSubstractView)

        joystickView.backgroundColor = .red
        joystickView.layer.cornerRadius = CGFloat(joystickSize / 2)
        joystickSubstractView.addSubview(joystickView)

        scrollView.snp.makeConstraints {
            $0.width.height.equalTo(substractSize)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
        }

        joystickSubstractView.snp.makeConstraints {
            $0.width.height.equalTo((substractSize - joystickSize) + substractSize)
            $0.edges.equalToSuperview()
        }

        joystickView.snp.makeConstraints {
            $0.width.height.equalTo(joystickSize)
            $0.center.equalToSuperview()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentOffset = CGPoint(x: (substractSize - joystickSize) / 2, y: (substractSize - joystickSize) / 2)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // print("Content offest:      \(scrollView.contentOffset)")
//        // View center: (207.0, 448.0)
//        print("Center:    \(self.view.center)")
//        print("ScrollView center:    \(scrollView.center)")
//        print("joystickView center:  \(joystickView.convert(joystickView.center, to: self.view))")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let substractRayon = substractSize / 2
        let joystickRayon = joystickSize / 2
        let substractCenter = scrollView.center
        let joystickCenter = joystickView.convert(joystickView.center, to: self.view)
        let distanceBetweenCenters = hypot((joystickCenter.x - joystickView.frame.minX) - substractCenter.x,
                                           (joystickCenter.y - joystickView.frame.minY) - substractCenter.y)

        if CGFloat(substractRayon) >= (distanceBetweenCenters + CGFloat(joystickRayon)) {
            print("Inside")
        } else {
            let point = CGPoint(x: substractCenter.x + ((joystickCenter.x - joystickView.frame.minX) - substractCenter.x),
                                y: substractCenter.y + ((joystickCenter.y - joystickView.frame.minY) - substractCenter.y))
            print("Point:               \(point)")
            print("ScrollView center:   \(scrollView.center)")
            print("Offset:              \(scrollView.contentOffset)")
            print("Test:                \(scrollView.convert(point, to: scrollView))")
            print()
        }

        /*
        if scrollView.contentOffset.x <= 15 && scrollView.contentOffset.y >= 85 {
            scrollView.contentOffset = CGPoint(x: 15, y: 85)
        } else if scrollView.contentOffset.x >= 85 && scrollView.contentOffset.y >= 85 {
            scrollView.contentOffset = CGPoint(x: 85, y: 85)
        } else if scrollView.contentOffset.x >= 85 && scrollView.contentOffset.y <= 15 {
            scrollView.contentOffset = CGPoint(x: 85, y: 15)
        } else if scrollView.contentOffset.x <= 15 && scrollView.contentOffset.y <= 15 {
            scrollView.contentOffset = CGPoint(x: 15, y: 15)
        }
        */
    }
}
