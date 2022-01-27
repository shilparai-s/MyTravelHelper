//
//  App-Errors.swift
//  MyTravelHelper
//
//  Created by Shilpa S on 24/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation

protocol THError: Error {
    var message: String { get }
}

enum NetworkError: THError {
    case invalidRequest
    case timeout
    case notReachable
    case noData
    
    var message: String {
        switch self {
            case .invalidRequest: return "Invalid Request"
            case .timeout: return "Request Timeout"
            case .notReachable: return "Network not reachable"
            case .noData: return "No Data found"
        }
    }
}

enum ParsingError: THError {
    case invalidData
    var message: String {
        return "Parsing Error. Invalid Data"
    }
}

enum UnknowError: THError {
    case unknowError
    var message: String {
        return "Unknown Error"
    }
}

