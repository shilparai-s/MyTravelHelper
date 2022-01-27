//
//  MockDataTask.swift
//  MyTravelHelperTests
//
//  Created by Shilpa S on 20/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

class MockDataTask: URLSessionDataTask {
    
    var data: Data?
    var httpResponse: HTTPURLResponse?
    var requestError: Error?
    
    init(data: Data?, respones: HTTPURLResponse?, error: Error?) {
        self.data = data
        self.httpResponse = respones
        self.requestError = error
    }
    
    override func resume() {
        
    }
}
