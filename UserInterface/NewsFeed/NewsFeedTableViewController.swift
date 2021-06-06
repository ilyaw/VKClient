//
//  NewsFeedTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import UIKit

class NewsFeedTableViewController: UITableViewController {
    let newsCell = "NewsCell"
    
    let allNews = getAllNews()
    
    private let networkManager = NetworkManager.shared
    private let realmManager = RealmManager.shared
    
    private var newsFeed: [NewsFeed]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: newsCell)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        
        loadData()
    }
    
    func loadData() {
        networkManager.getNewsFeed { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let newsFeed):
                self?.newsFeed = newsFeed
                self?.tableView.reloadData()
            }
        }
    }   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeed?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: newsCell, for: indexPath) as? NewsFeedTableViewCell,
            let newsFeedItem = newsFeed?[indexPath.row] else { return UITableViewCell() }
        
        cell.setup(newsFeed: newsFeedItem)

        return cell
    }
    
}
