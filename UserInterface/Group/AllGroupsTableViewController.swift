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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return AllGroupsTableViewController.groups.count
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
        
        NetworkManager.shared.searchGroups(textSearch: searchText, count: 50) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let groups):
                self?.searchGroups = groups
                self?.tableView.reloadData()
            }
        }
    }
}
