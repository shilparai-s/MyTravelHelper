//
//  SearchRequestLoader.swift
//  MyTravelHelper
//
//  Created by Shilpa S on 24/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

class SearchRequestLoader: APILoader {
    
    private var session: URLSession
    private var reachability: Reach
    
    required init(session: URLSession = .shared, reachability: Reach = Reach()) {
        self.session = session
        self.reachability = reachability
    }
    
    func execute<U>(service: U, parameters: [String : String], onCompletion: @escaping (U.ResponseDataType?, Error?) -> ()) where U : APIHandler   {
        
        if self.reachability.isNetworkReachable() == true {
            
            let request = service.makeRequest(from: parameters)
            
            print(request.urlRequest)
            self.session.dataTask(with: request.urlRequest, completionHandler: {
                 (data, response,error) in
                if let responseData = data {
                    do {
                        let responseObj = try service.processResponse(from: responseData)
                        DispatchQueue.main.async {
                            onCompletion(responseObj,nil)
                        }
                    }catch {
                        DispatchQueue.main.async {
                            onCompletion(nil,ParsingError.invalidData)
                        }
                    }
                    
                }else {
                    DispatchQueue.main.async {
                        onCompletion(nil,NetworkError.noData)
                    }
                }
            }).resume()
        } else {
            onCompletion(nil,NetworkError.notReachable)
        }
        
    }
    
    
}
