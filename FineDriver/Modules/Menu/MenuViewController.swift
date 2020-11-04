//
//  MenuViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class MenuViewController: BaseViewController {
    
    private enum Layout {
        enum TableView {
            static let height: CGFloat = 58.0
        }
    }

    // MARK: - Private outlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet fileprivate weak var topConstraint: NSLayoutConstraint!
    
    fileprivate var oldContentOffset = CGPoint.zero

    // MARK: - Public properties
    var presenter: MenuPresenterProtocol!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    // MARK: - Private methods
    private func setupView() {
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        
        presenter?.fetchImage(imageView: avatarImageView)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MenuCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: MenuCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - MenuViewControllerProtocol

extension MenuViewController: MenuViewControllerProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Delegate methods

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Layout.TableView.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellModel = presenter.model(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as? MenuCell else { return UITableViewCell() }
        cell.update(model: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            presenter?.routeMap()
        case 1:
            presenter?.routeFines()
        case 3:
            presenter?.routeProfile()
        case 4:
            presenter?.routeSetting()
        case 6:
            presenter?.routeAuth()
        default:
            break
        }
    }
}

extension MenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView)
////        UIView.animate(withDuration: 0.25) {
//        let y = scrollView.contentOffset.y
//        topConstraint.constant = 143 - y
//        view.layoutIfNeeded()
//        }
        
        /*
        //ScrollView's contentOffset differences with previous contentOffset
        let contentOffset =  scrollView.contentOffset.y - oldContentOffset.y
      
        // Scrolls UP - we compress the top view
        if contentOffset > 0 && scrollView.contentOffset.y > 0 {
            if (topConstraint.constant > -120 ) {
                topConstraint.constant -= contentOffset
                scrollView.contentOffset.y -= contentOffset
            }
        }
        
        // Scrolls Down - we expand the top view
        if contentOffset < 0 && scrollView.contentOffset.y < 0 {
//            if (topConstraint.constant < 143) {
                if topConstraint.constant - contentOffset > 0 {
                    topConstraint.constant += abs(contentOffset)
                } else {
                    topConstraint.constant -= contentOffset
                }
                scrollView.contentOffset.y -= contentOffset
//            }
        }
        oldContentOffset = scrollView.contentOffset
 */
    }
}
