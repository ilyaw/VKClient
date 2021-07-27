//
//  NewsfeedViewController.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedDisplayLogic: AnyObject {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic {
    
    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    
    private lazy var footerView = FooterView()
    
    private var feedViewModel = FeedViewModel(cells: [], footerTitle: nil)
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(NewsfeedCell.self, forCellReuseIdentifier: NewsfeedCell.reuseId)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.prefetchDataSource = self
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            tableView.allowsSelection = false
            tableView.contentInset.top = 8
            tableView.addSubview(refreshControl)
            tableView.tableFooterView = footerView
        }
    }
    
    private var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    @objc private func refresh() {
        interactor?.makeRequest(request: .getNewsfeed)
    }
    
    private func setupTopBars() {
        
        var frame: CGRect?
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            frame = window?.windowScene?.statusBarManager?.statusBarFrame
        } else {
            frame = UIApplication.shared.statusBarFrame
        }
        
        if let frame = frame {
            let topBar = UIView(frame: frame)
            topBar.backgroundColor = .white
            topBar.layer.shadowColor = UIColor.black.cgColor
            topBar.layer.shadowOpacity = 0.5
            topBar.layer.shadowOffset = CGSize.zero
            topBar.layer.shadowRadius = 8
            self.view.addSubview(topBar)
        }
    }
    
    
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewsfeed(feedViewModel: let feedViewModel):
            self.feedViewModel = feedViewModel
            tableView.reloadData()
            refreshControl.endRefreshing()
            footerView.setTitle(feedViewModel.footerTitle)
        case .displayFooterLoader:
            footerView.showLoader() //активируем лоадер
        }
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsfeedInteractor()
        let presenter             = NewsfeedPresenter()
        let router                = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
        
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTopBars()
        
        interactor?.makeRequest(request: .getNewsfeed)
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseId, for: indexPath) as? NewsfeedCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = feedViewModel.cells[indexPath.row]
        
        cell.setup(viewModel: cellViewModel)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}

extension NewsfeedViewController: NewsfeedCodeCellDelegate {
    
    // разворачиваем текст на фул
    func revealPost(for cell: NewsfeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
    
}

extension NewsfeedViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxIndex = indexPaths.map({ $0.row }).max() else { return }
        
        if maxIndex > feedViewModel.cells.count - 2  {
            interactor?.makeRequest(request: .getNextBatch)
        }
    }
}
