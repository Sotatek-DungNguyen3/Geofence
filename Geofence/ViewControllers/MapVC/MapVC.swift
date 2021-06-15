//
//  MapVC.swift
//  Geofence
//
//  Created by Nguyen Tan Dung on 10/06/2021.
//

import UIKit

class MapVC: UIViewController {

    @IBOutlet weak var viewMap: MapView!
    
    //Outside geofence
    private let geoLat = 21.00184
    private let geoLon = 105.81620
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        viewMap.ondidEventRegion = { [weak self] (status) in
            self?.showAlert(title: status == .enter ? "Enter region" : "Exit region",
                            message: status == .enter ? "Test enter region" : "Test exit region",
                            okTitle: "Ok", okAction: nil)
        }
    }
    
    @IBAction func testClick(_ sender: Any) {
        viewMap.getCurrentLocation()
    }
}
