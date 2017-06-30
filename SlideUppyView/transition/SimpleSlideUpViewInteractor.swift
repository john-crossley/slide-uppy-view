//
//  Copyright © 2017 John Crossley. All rights reserved.
//

import UIKit

class SimpleSlideUpInteractor: UIPercentDrivenInteractiveTransition {

    private var viewController: UIViewController?
    private var presentViewController: UIViewController?

    private var percent: CGFloat = 0
    private let threshold: CGFloat
    private var shouldComplete: Bool {
        return self.percent > self.threshold
    }

    private lazy var panGesture: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(onPan(pan:)))
    }()

    init(threshold: CGFloat) {
        self.threshold = threshold
    }

    func attach(to viewController: UIViewController, with view: UIView, present: UIViewController?) {
        self.viewController = viewController
        self.presentViewController = present
        view.addGestureRecognizer(panGesture)
    }

    @objc private func onPan(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        let screenHeight = UIScreen.main.bounds.size.height - BottomBar.height
        let dragAmount = (presentViewController == nil) ? screenHeight : -screenHeight

        percent = translation.y / dragAmount

        switch pan.state {
        case .began:
            if let presentViewController = presentViewController {
                viewController?.present(presentViewController, animated: true, completion: nil)
            } else {
                viewController?.dismiss(animated: true, completion: nil)
            }

        case .changed:
            update(percent)
        case .ended, .cancelled:
            if pan.state == .cancelled || !self.shouldComplete {
                cancel()
            } else {
                finish()
            }
        default: break
        }
    }

}

