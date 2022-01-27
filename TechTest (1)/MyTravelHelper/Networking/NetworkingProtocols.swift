//
//  NetworkingProtocols.swift
//  MyTravelHelper
//
//  Created by Shilpa S on 24/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

enum TravelHelperConstants {
    static let baseURL: String = "http://api.irishrail.ie/realtime/realtime.asmx/"
    static let stationCode: String = "StationCode"
    static let trainId: String = "TrainId"
    static let trainDate: String = "TrainDate"
}


enum EndPoint {
    case allStations
    case stationDetails
    case trainDetails
    
    var path: String {
        switch self {
        case .allStations:
            return "getAllStationsXML"
        case .stationDetails:
            return "getStationDataByCodeXML"
        case .trainDetails:
            return "getTrainMovementsXML"
        }
    }
}

protocol RequestBuilder {
    func build(path: String, parameters: [String: String]) -> URLRequest
}

protocol Request {
    var urlRequest: URLRequest {  get }
    var path: String {set get}
}

protocol APIHandler {
    associatedtype ResponseDataType
    init() 
    func makeRequest(from params: [String: String]) -> Request
    func processResponse(from data: Data) throws -> ResponseDataType
}

protocol APILoader {
    init(session: URLSession, reachability: Reach)
    func execute<U:APIHandler>(service: U, parameters: [String: String], onCompletion : @escaping (U.ResponseDataType?, Error?)->())
}

