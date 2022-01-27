//
//  StationListService.swift
//  MyTravelHelper
//
//  Created by Shilpa S on 24/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation
import XMLParsing

struct StationListService: APIHandler {
    
    typealias ResponseDataType = Stations
    
    init() {
    }
        
    func makeRequest(from params: [String : String]) -> Request {
        return BaseRequest(path: EndPoint.allStations.path)
    }
    
    func processResponse(from data: Data) throws -> Stations {
        if let station = try? XMLDecoder().decode(Stations.self, from: data) {
            return station
        } else {
            throw ParsingError.invalidData
        }
    }
}
