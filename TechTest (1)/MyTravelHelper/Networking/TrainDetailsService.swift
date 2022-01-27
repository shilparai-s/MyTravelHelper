//
//  TrainDetailsService.swift
//  MyTravelHelper
//
//  Created by Shilpa S on 24/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation
import XMLParsing

struct TrainDetailsService: APIHandler {
    
    
    typealias ResponseDataType = TrainMovementsData
    
    func makeRequest(from params: [String : String]) -> Request {
        return BaseRequest(path: EndPoint.trainDetails.path, parameters: params)
    }

    func processResponse(from data: Data) throws -> TrainMovementsData {
        if let TrainMovementsData = try? XMLDecoder().decode(TrainMovementsData.self, from: data) {
            return TrainMovementsData
        } else {
            throw ParsingError.invalidData
        }
    }
    
}

