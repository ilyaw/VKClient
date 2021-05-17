//
//  ReloadFriendsController.swift
//  UserInterface
//
//  Created by Ilya on 11.05.2021.
//

import Foundation

//Обновить данные
class ReloadFriendsControllerOperation: Operation {
    var controller: ReloadDataTableController
    
    init(controller: ReloadDataTableController) {
        self.controller = controller
    }
    
    override func main() {
        guard (dependencies.first as? ParseFriendsOperation) != nil else { return }
        controller.reloadData()
    }
}
