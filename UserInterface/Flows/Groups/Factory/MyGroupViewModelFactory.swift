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
    let shortInfo: String
    let photoURL: String
    var isMember: Bool
}

final class AllGroupViewModelFactory {
    
    private var infoGroups: [GroupInfo]?
    
    func constuctViewModels(groups: [GroupItem], infoGroups: [GroupInfo]) -> [GroupViewModel] {
        self.infoGroups = infoGroups
        return groups.map(viewModel)
    }
    
    private func viewModel(from group: GroupItem) -> GroupViewModel {
        let id = String(group.id)
        let title = group.name
        let photoURL = group.photo
        let isMember = group.isMember
        var shortInfo = ""
        
        if let infoGroup = infoGroups?.first(where: { $0.id == group.id }) {
            let membersCount = infoGroup.membersCount ?? 0
            let activity = infoGroup.activity ?? ""
            
            let text = String.localizedStringWithFormat(NSLocalizedString("members count", comment: ""),
                                                        membersCount)
            
            shortInfo = "\(activity), \(text)"
        }
        
        return GroupViewModel(id: id,
                              title: title,
                              shortInfo: shortInfo,
                              photoURL: photoURL,
                              isMember: isMember)
    }
}
