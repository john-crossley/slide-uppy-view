//
//  Copyright © 2017 John Crossley. All rights reserved.
//

import UIKit

class SimpleSlideUpViewAnimator: NSObject {

    private var action: TransitionAction = .present
    private let startingY: CGFloat
    fileprivate let transitionDuration = 0.8

    private let fakeBottomBar: UIView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: BottomBar.height)
        return BottomBar(frame: frame)
    }()

    init(y: CGFloat, action: TransitionAction) {
        self.startingY = y
        self.action = action
    }

    func animate(with action: TransitionAction,
                 context: UIViewControllerContextTransitioning,
                 fromController: UIViewController,
                 toController: UIViewController) {

        let container = context.containerView
        let fakeBottomBar = self.fakeBottomBar
        let startingFrame = calculateStartingFrame(using: context, for: fromController, with: action)

        if action == .present {

            var endingFrame = startingFrame
            endingFrame.origin.y = endingFrame.size.height - self.startingY
            toController.view.frame = endingFrame
            toController.view.addSubview(fakeBottomBar)
            container.addSubview(fromController.view)
            container.addSubview(toController.view)

        } else if action == .dismiss {
            fakeBottomBar.alpha = 0
            fromController.view.addSubview(fakeBottomBar)
            container.addSubview(toController.view)
            container.addSubview(fromController.view)
        }

        UIView.animate(withDuration: transitionDuration(using: context),
                       delay: 0,
                       options: .curveLinear,
                       animations: {

                        if action == .present {
                            toController.view.frame = startingFrame
                            fakeBottomBar.alpha = 0
                        } else if action == .dismiss {
                            fromController.view.frame = startingFrame
                            fakeBottomBar.alpha = 1
                        }

        }) { (hasFinished) in
            fakeBottomBar.removeFromSuperview()
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition(true)
            }
        }
    }

    private func calculateStartingFrame(using context: UIViewControllerContextTransitioning,
                                        for controller: UIViewController,
                                        with action: TransitionAction) -> CGRect {

        var startingFrame = context.initialFrame(for: controller)

        if action == .dismiss {
            startingFrame.origin.y = startingFrame.size.height - self.startingY
        }

        return startingFrame
    }
}

extension SimpleSlideUpViewAnimator: UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewController(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to) else { return }
        animate(with: action, context: transitionContext, fromController: fromController, toController: toController)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
}
