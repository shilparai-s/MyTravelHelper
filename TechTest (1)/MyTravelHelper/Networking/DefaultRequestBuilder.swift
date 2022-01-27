//
//  DefaultRequestBuilder.swift
//  MyTravelHelper
//
//  Created by Shilpa S on 25/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

class DefaultRequestBuilder: RequestBuilder {
    
    func build(path: String, parameters: [String : String]) -> URLRequest {
        
        let url = URL(string: TravelHelperConstants.baseURL + path)!
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponent.queryItems = self.queryParameters(from: parameters)
        if let url = urlComponent.url  {
            return URLRequest(url: url)
        } else {
            return URLRequest(url: url)
        }
    }
    
    private func queryParameters(from params: [String: String]) -> [URLQueryItem] {
       var queryParams = [URLQueryItem]()
        for (k,v) in params {
            queryParams.append(URLQueryItem(name:k , value: v))
        }
        return queryParams
    }
}
