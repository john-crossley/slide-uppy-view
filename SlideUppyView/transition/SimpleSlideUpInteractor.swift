//
//  MiniToLargeViewInteractor.swift
//  SlideUppyView
//
//  Created by John Crossley on 30/06/2017.
//  Copyright © 2017 John Crossley. All rights reserved.
//

import UIKit

class MiniToLargeViewInteractor: UIPercentDrivenInteractiveTransition {

    var viewController: UIViewController?
    var presentViewController: UIViewController?

    var shouldComplete = false
    var lastProgress: CGFloat?

    private lazy var panGesture: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(onPan(pan:)))
    }()

    func attach(to viewController: UIViewController, with view: UIView, present: UIViewController?) {
        self.viewController = viewController
        self.presentViewController = present
        view.addGestureRecognizer(panGesture)
    }

    @objc private func onPan(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)

        // represents the % of the transition that must be completed before allowing to complete
        let percentThreshold: CGFloat = 0.2

        // represents the difference between progress that is required to trigger completion in transition
        let automaticOverrideThreshold: CGFloat = 0.03

        let screenHeight = UIScreen.main.bounds.size.height - BottomBar.height
        let dragAmount = (presentViewController == nil) ? screenHeight : -screenHeight

        let progress = translation.y / dragAmount

        switch pan.state {
        case .began:
            if let presentViewController = presentViewController {
                viewController?.present(presentViewController, animated: true, completion: nil)
            } else {
                viewController?.dismiss(animated: true, completion: nil)
            }

        case .changed:
            guard let lastProgress = lastProgress else { return }

            if lastProgress > progress {
                shouldComplete = false
            } else if progress > lastProgress + automaticOverrideThreshold {
                shouldComplete = true
            } else {
                shouldComplete = progress > percentThreshold
            }

            update(progress)

        case .ended, .cancelled:
            if pan.state == .cancelled || !shouldComplete {
                cancel()
            } else {
                finish()
            }
        default: break
        }

        lastProgress = progress
    }

}
