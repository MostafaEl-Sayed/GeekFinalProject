//
//  User.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/14/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import Foundation
import GoogleMaps
class BlueLine {
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var selectedRoute: NSDictionary!
    var overviewPolyline: NSDictionary!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    var destinationAddress: String!
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var routePolyline: GMSPolyline!
    
    
    init(blueLineData:NSDictionary) {
        self.selectedRoute = blueLineData.getValueForKey(Key: "routes", callBack: [])[0] as! NSDictionary
        self.overviewPolyline = selectedRoute.getValueForKey(Key: "overview_polyline", callBack: [:])
        let legs:[NSDictionary] = selectedRoute.getValueForKey(Key: "legs", callBack: [])
        let startLocationDictionary:NSDictionary = legs[0].getValueForKey(Key: "start_location", callBack: [:])
        originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary.getValueForKey(Key: "lat", callBack: 0.0), startLocationDictionary.getValueForKey(Key: "lng", callBack: 0.0))
        let endLocationDictionary:NSDictionary = legs[legs.count - 1].getValueForKey(Key: "end_location", callBack: [:])
        self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary.getValueForKey(Key: "lat", callBack: 0.0), endLocationDictionary.getValueForKey(Key: "lng", callBack: 0.0))
        self.originAddress = legs[0].getValueForKey(Key: "start_address", callBack: "")
        self.destinationAddress = legs[legs.count - 1].getValueForKey(Key: "end_address", callBack: "")
        
    }
    
}
