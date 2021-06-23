//
//  GroupViewModelFactory.swift
//  UserInterface
//
//  Created by Ilya on 23.06.2021.
//

import Foundation

struct GroupViewModel {
    let title: String
    let photoURL: String
}

final class GroupViewModelFactory {
    
    func constuctViewModels(with groups: [GroupItem]) -> [GroupViewModel] {
        return groups.map(viewModel)
    }
    
    private func viewModel(from group: GroupItem) -> GroupViewModel {
        let title = group.name
        let photoURL = group.photo50
        
        return GroupViewModel(title: title, photoURL: photoURL)
    }
    
}
