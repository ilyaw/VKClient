//
//  GroupViewModelFactory.swift
//  UserInterface
//
//  Created by Ilya on 23.06.2021.
//

import Foundation

struct GroupViewModel {
    let id: String
    let title: String
    let photoURL: String
    var isMember: Bool
}

final class GroupViewModelFactory {
    
    func constuctViewModels(with groups: [GroupItem]) -> [GroupViewModel] {
        return groups.map(viewModel)
    }
    
    private func viewModel(from group: GroupItem) -> GroupViewModel {
        let id = String(group.id)
        let title = group.name
        let photoURL = group.photo
        let isMember = group.isMember
        
        return GroupViewModel(id: id,
                              title: title,
                              photoURL: photoURL,
                              isMember: isMember)
    }
    
}
