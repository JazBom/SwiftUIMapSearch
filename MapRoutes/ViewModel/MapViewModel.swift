//
//  MapViewModel.swift
//  MapRoutes
//
//  Created by Jessica Bommer on 22/10/21.
//

import SwiftUI
import MapKit
import CoreLocation

//All Map Data here

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // mapview
    @Published var mapView = MKMapView()

    // Region
    @Published var region : MKCoordinateRegion!
    // Based on Location it will set up

    // Alert
    @Published var permissionDenied = false

    // Map Type
    @Published var mapType : MKMapType = .standard

    // SearchText
    @Published var searchText = ""

    // Searched Places
    @Published var places: [Place] = []

    // Updating Map Type

    func updateMapType(){

        if mapType == .standard{
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }

    }

    // Focus Location

    func focusLocation(){

        guard let _ = region else { return }

        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }

    // Search Places

    func searchQuery(){

        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText

        // Fetch
        MKLocalSearch(request: request).start { (response, _) in
            // this is not working!!! Something weird with place/placemark stuff
            guard let result = response else { return }

            self.places = result.mapItems.compactMap({ (item) -> Place? in

                return Place(place: item.placemark)
                
            })
        }
    }
    // Pick search result

    func selectPlace(place: Place){
        // showing pin on map
        searchText = ""
        guard let selectedCoordinate = place.place.location?.coordinate else { return }
    
        let pointAnnotation = MKPointAnnotation()

        pointAnnotation.coordinate = selectedCoordinate
        pointAnnotation.title = place.place.name ?? "No name"
        //remove all old ones
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnnotation)

        // Moving map to that location

        let coordinateRegion = MKCoordinateRegion(center: selectedCoordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)

    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
     // checking permissions

        switch manager.authorizationStatus {
        case .denied:
            // Alert...
            permissionDenied.toggle()
        case .notDetermined:
            //Requesting...
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            //permission granted
            manager.requestLocation()
        default:
            ()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // error handling
        print(error.localizedDescription)
    }

    // Getting user region

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)

        //update map
        self.mapView.setRegion(self.region, animated: true)
        // smooth animation
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}
