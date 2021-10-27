//
//  Place.swift
//  MapRoutes
//
//  Created by Jessica Bommer on 27/10/21.
//
import SwiftUI
import MapKit

struct Place: Identifiable {

    var id = UUID().uuidString
    var place: CLPlacemark

}

