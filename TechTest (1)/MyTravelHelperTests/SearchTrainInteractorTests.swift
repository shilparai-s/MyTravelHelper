//
//  SearchTrainInteractorTests.swift
//  MyTravelHelperTests
//
//  Created by Shilpa S on 20/01/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import XCTest
import XMLParsing
@testable import MyTravelHelper

class SearchTrainInteractorTests: XCTestCase {
    
    var interactor: SearchTrainInteractor!
    var mockPresentor = SearchTrainPresenterMock()
    var mockRequestLoader =  MockRequestLoader(session: .shared, reachability: Reach())
    var dateFormatter: DateFormatter!
    

    override func setUpWithError() throws {
        interactor = SearchTrainInteractor(loader:mockRequestLoader)
        interactor.presenter = mockPresentor
        
        dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "IR")
        dateFormatter.dateFormat = "dd/MM/yyyy"
    }

    override func tearDownWithError() throws {
        interactor = nil
    }

    func testFetchAllStations() throws {
        
        let expectation = XCTestExpectation(description: "fetchAllStations")
        mockRequestLoader.allStationsResponse = Stations(stationsList: [Station(desc: "Belfast", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)])
        
        self.interactor.fetchallStations()
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertFalse((self.mockPresentor.stationFetchSuccess))
    }
    
    func testTrainsBetweenStations() throws {
        let expectation = XCTestExpectation(description: "StationDesc")
        

        mockRequestLoader.stationDetailsResponse = StationData(trainsList: [StationTrain(trainCode: "D314", fullName: "Ashtown", stationCode: "ASHTN", trainDate: dateFormatter.string(from: Date()), dueIn: 1, lateBy: 2, expArrival: "18:12", expDeparture: "18:12"),StationTrain(trainCode: "D929", fullName: "Ashtown", stationCode: "ASHTN", trainDate: dateFormatter.string(from: Date()), dueIn: 1, lateBy: 2, expArrival: "18:18", expDeparture: "18:19")])
        
        mockRequestLoader.trainDetailsResponse = TrainMovementsData(trainMovements: [
            TrainMovement(trainCode: "D314", locationCode: "DCKLS", locationFullName: "Docklands", expDeparture: dateFormatter.string(from: Date())),
            TrainMovement(trainCode: "D314", locationCode: "NEWCJ", locationFullName: "Newcomen Junction", expDeparture: dateFormatter.string(from: Date())),
            TrainMovement(trainCode: "D314", locationCode: "GLASJ", locationFullName: "Glasnevin Junction", expDeparture: dateFormatter.string(from: Date())),
            TrainMovement(trainCode: "D314", locationCode: "BBRDG", locationFullName: "Broombridge", expDeparture: dateFormatter.string(from: Date())),
            TrainMovement(trainCode: "D314", locationCode: "PELTN", locationFullName: "Pelletstown", expDeparture: dateFormatter.string(from: Date())),
            TrainMovement(trainCode: "D314", locationCode: "ASHTN", locationFullName: "Ashtown", expDeparture: dateFormatter.string(from: Date()))])
        
        self.interactor.fetchTrainsFromSource(sourceCode: "DCKLS", destinationCode: "ASHTN")
        expectation.fulfill()

        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(self.mockPresentor.isTrainsAvailable, true)
        
    }
    
    func testNoTrainsBetweenStations() throws {
        
        let expectation = expectation(description: "noTrainsBetweenStations")
        
        mockRequestLoader.stationDetailsResponse = StationData(trainsList: [StationTrain(trainCode: "BFSTC", fullName: "Belfast", stationCode: "123", trainDate: dateFormatter.string(from: Date()), dueIn: 10, lateBy: 0, expArrival: "", expDeparture: "")])
        
        mockRequestLoader.trainDetailsResponse = TrainMovementsData(trainMovements: [])

        MockURLProtocol.requestHandler = {
            _ in
            let responseData = try XMLEncoder().encode([StationTrain](), withRootKey: "ArrayOfObjStation")
            return (responseData,HTTPURLResponse())
        }

        self.interactor.fetchTrainsFromSource(sourceCode: "xyz", destinationCode: "abc")
        expectation.fulfill()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(self.mockPresentor.isTrainsAvailable, false)
    }
}

class SearchTrainPresenterMock: InteractorToPresenterProtocol {
    
    var stationFetchSuccess: Bool = false
    var isTrainsAvailable: Bool = false
    
    func stationListFetched(list: [Station]) {
        stationFetchSuccess = true
    }
    
    func fetchedTrainsList(trainsList: [StationTrain]?) {

        if let _ = trainsList {
            isTrainsAvailable = true
        }
    }
    
    func showNoTrainAvailbilityFromSource() {

        isTrainsAvailable = false
    }
    
    func showNoInterNetAvailabilityMessage() {
        
    }
}

class MockRequestLoader: APILoader {
    
    var allStationsResponse : Stations?
    var stationDetailsResponse : StationData?
    var trainDetailsResponse : TrainMovementsData?
    
    required init(session: URLSession, reachability: Reach) {
        
    }
    
    func execute<U>(service: U, parameters: [String : String], onCompletion: @escaping (U.ResponseDataType?, Error?) -> ()) where U : APIHandler {
        let request = service.makeRequest(from: parameters)
        
        if request.path == EndPoint.allStations.path {
            XCTAssertNotNil(allStationsResponse)
            onCompletion(allStationsResponse as? U.ResponseDataType,nil)
        } else if request.path == EndPoint.stationDetails.path {
            XCTAssertNotNil(stationDetailsResponse)
            onCompletion(stationDetailsResponse as? U.ResponseDataType,nil)
        } else if request.path == EndPoint.trainDetails.path {
            XCTAssertNotNil(trainDetailsResponse)
            onCompletion(trainDetailsResponse as? U.ResponseDataType,nil)
        }
        
    }
    
    
}
