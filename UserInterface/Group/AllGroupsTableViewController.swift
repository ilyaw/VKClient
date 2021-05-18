//
//  AllGroupsTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {
    static let identifier = "GroupCell"
    
    var searchGroups: [GroupItem]?
    private let networkManager = NetworkManagerPromise.shared
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchGroups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllGroupsTableViewController.identifier, for: indexPath) as? AllGroupsTableViewCell,
              let group = self.searchGroups?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.setup(group)
        
        return cell
    }
}

extension AllGroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        networkManager.searchGroups(textSearch: searchText, on: .global())
            .get { [weak self] groups in
                self?.searchGroups = groups
            }
            .done(on: .main) { [weak self] _ in
                self?.tableView.reloadData()
            }
            .catch { [weak self] error in
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
    }
}
