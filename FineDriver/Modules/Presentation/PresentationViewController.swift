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
    @IBOutlet weak var skipButton: UIButton!

    var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    var presenter: PresentationPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

       bindUI()
       configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        presenter.getViewControllers()
    }
    
    fileprivate func configureUI() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        nextButton.setTitle("Seuraava", for: .normal)
    }
    
    fileprivate func bindUI() {
//        viewModel?.viewControllers
//            .skip(1)
//            .asObservable()
//            .subscribe(onNext: { [weak self] (viewControllers) in
//                self?.configurePageView(viewControllers: viewControllers)
//            })
//            .disposed(by: disposeBag)
        
//        nextButton.rx.tap
//            .asObservable()
//            .subscribe(onNext: {[weak self] (void) in
//                self?.scrollToNextViewController()
//            })
//            .disposed(by: disposeBag)
//
//        skipButton.rx.tap
//           .asObservable()
//           .subscribe(onNext: {[weak self] (void) in
//                self?.skipAction()
//           })
//           .disposed(by: disposeBag)
    }
    
    fileprivate func scrollToNextViewController() {
        if let visibleViewController = pageViewController.viewControllers?.first,
            let nextViewController = pageViewController(pageViewController, viewControllerAfter: visibleViewController) {
            pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            if let viewControllerIndex = presenter.viewControllers.firstIndex(of: nextViewController) {
                pageControl.currentPage = viewControllerIndex
                setButtonTitle(index: viewControllerIndex)
            }
        }else{
            skipAction()
        }
    }
    
    fileprivate func setButtonTitle(index: Int) {
        if let presenter = presenter,
            index == presenter.viewControllers.count - 1 {
            nextButton.setTitle("Viedä loppuun", for: .normal)
        }else{
            nextButton.setTitle("Seuraava", for: .normal)
        }
    }
    
    fileprivate func skipAction() {
        presenter.skip()
    }
    
    fileprivate func configurePageView(viewControllers: [UIViewController]) {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.didMove(toParent: self)
        
        view.bringSubviewToFront(pageControl)
        view.bringSubviewToFront(nextButton)
        view.bringSubviewToFront(skipButton)
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
            setButtonTitle(index: viewControllerIndex)
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return presenter.viewControllers.count
    }

}
