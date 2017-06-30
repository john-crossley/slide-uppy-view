//
//  ViewController.swift
//  SlideUppyView
//
//  Created by John Crossley on 29/06/2017.
//  Copyright © 2017 John Crossley. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController {

    fileprivate lazy var bottomBar: BottomBar = {
        let bottomBar = BottomBar()
        bottomBar.translatesAutoresizingMaskIntoConstraints = false

        return bottomBar
    }()

    private var products = [Product]() {
        didSet {
            collectionView?.reloadData()
        }
    }

    private var disableInteractivePlayerTransitioning = false
    private var presentInteractor = SimpleSlideUpInteractor(threshold: 0.3)
    private var dismissInteractor = SimpleSlideUpInteractor(threshold: 0.3)

    private static let productCellId = "productCellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ProductCell.self, forCellWithReuseIdentifier: HomeController.productCellId)

        products.append(Product(title: "MacBook Pro 13\"", description: "A nice shiny MacBook Pro"))
        products.append(Product(title: "iPhone 7 - 128GB", description: "A nice shiny iPhone"))

        setupBottomBar()
    }

    private func setupBottomBar() {

        view.addSubview(bottomBar)

        guard let collectionView = collectionView else { fatalError("Collection view is no dur bro? 💅🏻") }

        bottomBar.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        bottomBar.rightAnchor.constraint(equalTo: collectionView.rightAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: BottomBar.height).isActive = true 

        bottomBar.button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)

        let nextViewController = NextViewController()
        
        nextViewController.transitioningDelegate = self
        nextViewController.modalPresentationStyle = .fullScreen

        presentInteractor.attach(to: self, with: bottomBar, present: nextViewController)
        dismissInteractor.attach(to: nextViewController, with: nextViewController.view, present: nil)
    }

    @objc private func bottomButtonTapped(sender: UIButton) {

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeController.productCellId,
                                                            for: indexPath) as? ProductCell else {
            fatalError("Unable to dequeueReusableCell for \(HomeController.productCellId)")
        }

        let product = self.products[indexPath.row]

        cell.show(product: product)

        return cell
    }

}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 100)
    }
}

extension HomeController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SimpleSlideUpViewAnimator(y: BottomBar.height, action: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SimpleSlideUpViewAnimator(y: BottomBar.height, action: .dismiss)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return presentInteractor
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return dismissInteractor
    }

}
