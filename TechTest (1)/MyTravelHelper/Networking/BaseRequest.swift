//
//  BaseRequest.swift
//  MyTravelHelper
//
//  Created by Shilpa S on 24/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

class BaseRequest: Request {
    
    var urlRequest: URLRequest
    
    var path: String
    
    required init(path: String, parameters: [String: String] = [String: String]()) {
        self.path = path
        self.urlRequest = DefaultRequestBuilder().build(path: self.path, parameters: parameters)
    }
}
