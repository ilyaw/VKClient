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
    
    private let viewModelFactory = GroupViewModelFactory()
    private var viewModels: [GroupViewModel] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllGroupsTableViewController.identifier, for: indexPath) as? AllGroupsTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.setup(viewModels[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

extension AllGroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return
        }
        
        networkManager.searchGroups(textSearch: searchText, on: .global())
            .get { [weak self] groups in
                self?.viewModels = self?.viewModelFactory.constuctViewModels(with: groups) ?? []
            }
            .done(on: .main) { [weak self] _ in
                self?.tableView.reloadData()
            }
            .catch { [weak self] error in
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
    }
}

extension AllGroupsTableViewController: AllGroupsTableViewCellDelegate {
    func addGroup(for groupId: String?) {
        guard let id = groupId else { return }
        networkManager.addGroup(groupId: id, on: .global())
            .done(on: .main) { [weak self] _ in
                let index = self?.viewModels.firstIndex { $0.id == id }
                self?.viewModels[index!].isMember = true
                
                self?.tableView.reloadData()
            }
            .catch { [weak self] error in
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
    }
}
