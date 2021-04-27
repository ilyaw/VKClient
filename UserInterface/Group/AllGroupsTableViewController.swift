//
//  AllGroupsTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {

    let allGroup = "AllGroup"
  //  static var groups = getAllGroupsData()
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: allGroup, for: indexPath) as! AllGroupsTableViewCell

//        cell.groupName.text = AllGroupsTableViewController.groups[indexPath.row].name
//        cell.avatar.image = UIImage(named: AllGroupsTableViewController.groups[indexPath.row].photo)

        guard let group = self.searchGroups?[indexPath.row] else { return UITableViewCell() }
        
        cell.groupName.text = group.name
        
        if let url = URL(string: group.photo50) {
            DispatchQueue.global().async {
//                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.avatar.sd_setImage(with: url)
//                    cell.avatar.image = UIImage(data: data!)
                }
            }
        }
        
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
