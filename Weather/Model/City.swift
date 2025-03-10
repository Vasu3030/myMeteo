//
//  City.swift
//  weather
//
//  Created by AROUN Vassou on 28/09/2022.
//

import SwiftUI

struct City: Identifiable & Hashable & Codable & Decodable {
    var id: Int
    var wikiDataId: String
    var name: String
    var country: String
    var countryCode: String
    var region: String
    var regionCode: String
    var latitude: Float
    var longitude: Float
    var population: Float
}

struct LinkCity: Hashable & Codable {
    var rel: String
    var href: String
}

struct MetaDataCity: Hashable & Codable {
    var currentOffset: Int
    var totalCount: Int
}

struct ResponseCity: Decodable {
    var data: [City]
    var links: [LinkCity]
    var metadata: MetaDataCity
}
