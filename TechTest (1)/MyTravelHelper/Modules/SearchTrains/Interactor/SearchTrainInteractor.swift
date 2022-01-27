//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing

class SearchTrainInteractor: PresenterToInteractorProtocol, ServiceRequestProtocol {
    
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    var presenter: InteractorToPresenterProtocol?
    
    private var apiLoader: APILoader
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "IR")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    
    required init(loader: APILoader) {
        self.apiLoader = loader
    }


    func fetchallStations() {
        self.apiLoader.execute(service: StationListService(), parameters: [:], onCompletion: {
            [weak self] (stations, error) in
            DispatchQueue.main.async {
                guard let weakSelf = self else {
                    return
                }
                guard let allStations = stations?.stationsList else {
                    weakSelf.presenter!.stationListFetched(list: [])
                    return
                }
                weakSelf.presenter!.stationListFetched(list: allStations)
            }
        })
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        
        
        self.apiLoader.execute(service: StationDetailsService(),parameters: [TravelHelperConstants.stationCode:sourceCode], onCompletion: {
            [weak self] (stationData, error) in
            guard let weakSelf = self else {
                return
            }
            guard let _trainsList = stationData?.trainsList  else {
                weakSelf.presenter!.showNoTrainAvailbilityFromSource()
                return
            }
            weakSelf.proceesTrainListforDestinationCheck(trainsList: _trainsList)
        })

    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        var _trainsList = trainsList
        let today = Date()
        let group = DispatchGroup()
        let dateString = self.dateFormatter.string(from: today)
        
        for index  in 0...trainsList.count-1 {
            group.enter()
            
            self.apiLoader.execute(service: TrainDetailsService(),
                                   parameters: [TravelHelperConstants.trainId: trainsList[index].trainCode,
                                            TravelHelperConstants.trainDate: dateString],
                                   onCompletion:
                                    {
                    [weak self] (trainMovements, error) in
                    
                    guard let weakSelf = self else {
                        return
                    }
                    guard let _movements = trainMovements?.trainMovements else {
                        weakSelf.presenter!.showNoTrainAvailbilityFromSource()
                        return
                    }
                    let sourceIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(weakSelf._sourceStationCode) == .orderedSame})
                    let destinationIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(weakSelf._destinationStationCode) == .orderedSame})
                    let desiredStationMoment = _movements.filter{$0.locationCode.caseInsensitiveCompare(weakSelf._destinationStationCode) == .orderedSame}
                    let isDestinationAvailable = desiredStationMoment.count == 1

                    if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                        _trainsList[index].destinationDetails = desiredStationMoment.first
                    }

                    group.leave()
            })

        }

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
            
            if sourceToDestinationTrains.isEmpty {
                self.presenter!.showNoTrainAvailbilityFromSource()
            }else {
                self.presenter!.fetchedTrainsList(trainsList: sourceToDestinationTrains)
            }
        }
    }
}

