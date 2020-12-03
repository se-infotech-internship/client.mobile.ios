//
//  PresentationViewController.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 30.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class PresentationViewController: BaseViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    fileprivate var statusBarStyle = UIStatusBarStyle.lightContent {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }

    var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    var presenter: PresentationPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        presenter.getViewControllers()
    }
    
    fileprivate func configureUI() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = UIColor.white.cgColor
        
        addGradient()
    }
    
    fileprivate func addGradient() {
        DispatchQueue.main.async {
            self.gradientView.layer.compositingFilter = "multiplyBlendMode"

            let shadows = UIView()
            shadows.frame = self.gradientView.bounds
            shadows.clipsToBounds = false
            self.gradientView.addSubview(shadows)

            let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 0)
            let layer0 = CALayer()
            layer0.shadowPath = shadowPath0.cgPath
            layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            layer0.shadowOpacity = 1
            layer0.shadowRadius = 4
            layer0.shadowOffset = CGSize(width: 0, height: 4)
            layer0.bounds = shadows.bounds
            layer0.position = shadows.center
            shadows.layer.addSublayer(layer0)

            let shapes = UIView()
            shapes.frame = self.gradientView.bounds
            shapes.clipsToBounds = true
            self.gradientView.addSubview(shapes)

            let layer1 = CALayer()
            layer1.backgroundColor = UIColor(red: 0.13, green: 0.146, blue: 0.171, alpha: 1).cgColor
            layer1.bounds = shapes.bounds
            layer1.position = shapes.center
            shapes.layer.addSublayer(layer1)

            let layer2 = CAGradientLayer()
            layer2.colors = [
              UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
              UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
            ]
            layer2.locations = [0, 1]
            layer2.startPoint = CGPoint(x: 0.25, y: 0.5)
            layer2.endPoint = CGPoint(x: 0.75, y: 0.5)
            layer2.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
            layer2.bounds = shapes.bounds.insetBy(dx: -0.5*shapes.bounds.size.width, dy: -0.5*shapes.bounds.size.height)
            layer2.position = shapes.center
            shapes.layer.addSublayer(layer2)
        }
    }
        
    @IBAction fileprivate func scrollToNextViewController(_ sender: Any? = nil) {
        if let visibleViewController = pageViewController.viewControllers?.first,
            let nextViewController = pageViewController(pageViewController, viewControllerAfter: visibleViewController) {
            pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            if let viewControllerIndex = presenter.viewControllers.firstIndex(of: nextViewController) {
                pageControl.currentPage = viewControllerIndex
            }
        }else{
            skipAction()
        }
    }
    
    @IBAction fileprivate func skipAction(_ sender: Any? = nil) {
        presenter.skip()
    }

}

//MARK:- PresentationViewProtocol

extension PresentationViewController: PresentationViewProtocol {
    func configurePageView() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.setViewControllers([presenter.viewControllers[0]],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        pageViewController.didMove(toParent: self)
        
        view.bringSubviewToFront(pageControl)
        view.bringSubviewToFront(nextButton)
    }
}

//MARK:- UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension PresentationViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let presenter = presenter else {
            return nil
        }

        guard let viewControllerIndex = presenter.viewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }

        guard presenter.viewControllers.count > previousIndex else {
            return nil
        }
        
        return presenter.viewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let presenter = presenter else {
            return nil
        }

        guard let viewControllerIndex = presenter.viewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = presenter.viewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return presenter.viewControllers[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed == true else { return }

        if let viewControllerIndex = presenter.viewControllers.firstIndex(of: pageViewController.viewControllers!.first!) {
            pageControl.currentPage = viewControllerIndex
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return presenter.viewControllers.count
    }

}
