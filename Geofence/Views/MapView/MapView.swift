//
//  MapView.swift
//  Geofence
//
//  Created by Nguyen Tan Dung on 10/06/2021.
//

import UIKit
import GoogleMaps

enum RegionEvent {
    case enter
    case exit
}

@IBDesignable class MapView: BaseView {

    @IBOutlet private weak var viewGGMap: GMSMapView!

    private var locationManager: CLLocationManager!
    private var zoomLevel: Float = 12.0
    private var centerCircle = GMSCircle()
    private let searchRadius = 5000.0
    //Outside geofence
//    private let geoLat = 21.00184
//    private let geoLon = 105.81620
    
    //Inside geofence
    private let geoLat = 51.50861448576394
    private let geoLon = -0.12816601225338436

    var ondidEventRegion: ((RegionEvent) -> Void)?
    var isPermissionDenied: (() -> Void)?
    var tapOnMarker: ((Int) -> Void)?
    var updateLocation: ((_ lat: Double, _ lon: Double) -> Void)?
    var updateLocationMapCenter: ((_ lat: Double, _ lon: Double) -> Void)?
    var didUpdateLocation: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpMap()
    }

    override init() {
        super.init()
        setUpMap()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setUpMap() {
        let geofenceRegionCenter = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLon)
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: searchRadius, identifier: "notifymeonExit")
        geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.startMonitoring(for: geofenceRegion)
        viewGGMap.delegate = self
        viewGGMap.settings.myLocationButton = true
        viewGGMap.isMyLocationEnabled = true
        viewGGMap.settings.myLocationButton = false
    }

    func getCurrentLocation() {
        guard let lat = viewGGMap.myLocation?.coordinate.latitude,
        let lon = viewGGMap.myLocation?.coordinate.longitude else { return }
        moveMap(lat: lat, lon: lon)
    }

    func moveMap(lat: Double, lon: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lon , zoom: zoomLevel)
        viewGGMap.animate(to: camera)
        locationManager.startUpdatingLocation()
    }
    
    func drawCircle(centerOn coordinate: CLLocationCoordinate2D) {
        if centerCircle.map != nil {
            centerCircle.map = nil
        }
        centerCircle = GMSCircle(position: coordinate, radius: searchRadius)
        centerCircle.fillColor = UIColor.orange.withAlphaComponent(0.1)
        centerCircle.strokeColor = .orange
        centerCircle.strokeWidth = 2.0
        centerCircle.zIndex = -1
        centerCircle.map = viewGGMap
    }
    
    func changeRegion(status: RegionEvent) {
        ondidEventRegion?(status)
        getCurrentLocation()
    }
}

extension MapView: CLLocationManagerDelegate {
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        print("Location: \(location)")
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        let center = CLLocationCoordinate2D(
            latitude: geoLat,
            longitude: geoLon)
        drawCircle(centerOn: center)
        viewGGMap.camera = camera
        viewGGMap.animate(to: camera)
        if !didUpdateLocation {
           updateLocation?(location.coordinate.latitude, location.coordinate.longitude)
           didUpdateLocation = true
        }
    }
    
    // Handle exitting region event.
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        changeRegion(status: .exit)
    }

    // Handle enterring region event.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        changeRegion(status: .enter)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        guard let region = region else {
            print("Monitoring failed for unknown region")
            return
      }
        print("Monitoring failed for region with identifier: \(region.identifier)")
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            isPermissionDenied?()
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            print("Location status is still OK.")
        case .authorizedWhenInUse:
            print("Location status is OK")
        @unknown default:
            fatalError()
        }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension MapView: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let location: CLLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        updateLocationMapCenter?(location.coordinate.latitude, location.coordinate.longitude)
    }
}

