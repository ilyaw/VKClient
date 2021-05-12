//
//  GetDataOperation.swift
//  UserInterface
//
//  Created by Ilya on 11.05.2021.
//

import Foundation
import Alamofire

//Загрузка данных с сервера
class GetDataOperation: AsyncOperation {

    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    private var request: DataRequest
    var data: Data?
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
}
