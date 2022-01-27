//
//  SearchRequestFactory.swift
//  MyTravelHelper
//
//  Created by Shilpa S on 24/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

class SearchRequestFactory {
    
    func create(path: EndPoint, params: [String: String]) -> Request {
       
        switch path {
        case .allStations:
            let request = StationListService()
            return request.makeRequest(from: params)
        case .stationDetails:
            let request =  StationDetailsService()
            return request.makeRequest(from: params)
        case .trainDetails:
            let request =  TrainDetailsService()
            return request.makeRequest(from: params)

        }
    }
    
 }
