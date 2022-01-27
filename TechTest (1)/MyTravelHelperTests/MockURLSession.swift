//
//  MockURLSession.swift
//  MyTravelHelperTests
//
//  Created by Shilpa S on 20/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {
    var dataTask : MockDataTask?
    var completionHandler : ((Data?, URLResponse?, Error?) -> Void)?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.completionHandler = completionHandler
        return dataTask!
    }

}
