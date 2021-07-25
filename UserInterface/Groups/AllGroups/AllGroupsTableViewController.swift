//
//  AllGroupsTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {
    
    var searchGroups: [GroupItem]?
    private let networkManager = NetworkManagerPromise.shared
    
    private let viewModelFactory = AllGroupViewModelFactory()
    private var viewModels: [GroupViewModel] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        self.tableView.register(AllGroupsTableViewCell.self, forCellReuseIdentifier: AllGroupsTableViewCell.reuseId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllGroupsTableViewCell.reuseId, for: indexPath) as? AllGroupsTableViewCell else {
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
        
        searchGroup(searchText: searchText)
    }
    
    private func searchGroup(searchText: String) {
        networkManager.searchGroups(textSearch: searchText, on: .global())
            .get { [weak self] groups in
                self?.getByIdGroup(groups)
            }
            .catch { [weak self] error in
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
    }
    
    private func getByIdGroup(_ groups: [GroupItem]) {
        let ids = groups.map { "\($0.id)," }.reduce("", +).dropLast()
        
        self.networkManager.getByIdGroups(ids: String(ids))
            .get { [weak self] groupsInfo in
                self?.viewModels = self?.viewModelFactory.constuctViewModels(groups: groups, infoGroups: groupsInfo) ?? []
            }.done(on: .main) { [weak self] _ in
                self?.tableView.reloadData()
            } .catch { [weak self] error in
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
    }
}

extension AllGroupsTableViewController: AllGroupsTableViewCellDelegate {
    func addGroup(for groupId: String?) {
        guard let id = groupId else { return }
        networkManager.addGroup(groupId: id, on: .global())
            .done(on: .main) { [weak self] _ in
                if let index = self?.viewModels.firstIndex(where: { $0.id == id }) {
                    self?.viewModels[index].isMember = true
                    
                    self?.tableView.beginUpdates()
                    self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    self?.tableView.endUpdates()
                }
            }
            .catch { [weak self] error in
                self?.present(UIAlertController.create(error.localizedDescription), animated: true, completion: nil)
            }
    }
}
