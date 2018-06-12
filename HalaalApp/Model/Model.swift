//
//  Model.swift
//  HalaalApp
//
//  Created by ZainAnjum on 12/06/2018.
//  Copyright © 2018 ZainAnjum. All rights reserved.
//

import UIKit

struct Halal: Decodable {
    let property_status: String?
    let category_type: String?
    let bathrooms: String?
    let furnishings: String?
    let price: String?
    let latitude: String?
    let longitude: String?
    let description: String?
    let building_type: String?
    let building_age: String?
    let title: String?
    let dedicatedTo: String?
    let floors_number: String?
    let parking_type: String?
    let image_models: [imagesModel]?
}

struct imagesModel: Decodable {
    let image: String?
    
}

struct nearestMaps: Decodable {
    let results: [Results]?
    
}
struct Results: Decodable {
    let geometry: Geometry?
    let name: String?
}
struct Geometry: Decodable {
    let location: Location?
}
struct Location: Decodable {
    let lat: Double?
    let lng: Double?
}
