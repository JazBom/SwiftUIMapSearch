//
//  Home.swift
//  MapRoutes
//
//  Created by Jessica Bommer on 22/10/21.
//

import SwiftUI
import CoreLocation

struct Home: View {
    // Map Data
    @StateObject var mapData = MapViewModel()
    // Location Manager
    @State var locationManager = CLLocationManager()

    var body: some View {

        ZStack{
            // MapView
            MapView()
            // using as environment object so can be used in subViews
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)

            VStack{

                VStack(spacing: 0){

                    HStack{

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search", text: $mapData.searchText)
                            .colorScheme(.light)

                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white)

                    // Displaying results

                    if !mapData.places.isEmpty && mapData.searchText != "" {

                        ScrollView{

                            VStack(spacing: 15){

                                ForEach(mapData.places){item in
                                    Text(item.place.name ?? "")
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity,
                                               alignment: .leading)
                                        .padding(.leading)
                                        .onTapGesture {

                                            mapData.selectPlace(place: item)
                                        }

                                    Divider()
                                }
                            }
                            .padding(.top)
                        }
                        .background(Color.white)
                    }

                }
                .padding()

                Spacer()

                VStack{

                    Button(action: mapData.focusLocation, label: {

                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                    Button(action: mapData.updateMapType, label: {

                        Image(systemName: mapData.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }
        }
        .onAppear(perform: {
            //setting Delegate
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        // Permission denied alert
        .alert(isPresented: $mapData.permissionDenied, content: {

            Alert(title: Text("Permission denied"), message: Text("Please enable permission in app settings"), dismissButton: .default(Text("Go to settings"), action: {

                //Redirect User to settings
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapData.searchText, perform: {
            value in
            //searching places

            // delay to avoid Continuous Search Request
            let delay = 0.3

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.searchText{
                    // Search ...
                    self.mapData.searchQuery()
                }
            }
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
