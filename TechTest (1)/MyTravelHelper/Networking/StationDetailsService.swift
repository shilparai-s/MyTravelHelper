//
//  StationDetailsService.swift
//  MyTravelHelper
//
//  Created by Shilpa S on 24/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation
import XMLParsing

struct StationDetailsService: APIHandler {
        
    typealias ResponseDataType = StationData
    
    func makeRequest(from params: [String : String]) -> Request {
        return BaseRequest(path: EndPoint.stationDetails.path, parameters: params)
    }
    
    func processResponse(from data: Data) throws -> StationData {
        if let station = try? XMLDecoder().decode(StationData.self, from: data) {
            return station
        } else {
            throw ParsingError.invalidData
        }

    }
}

