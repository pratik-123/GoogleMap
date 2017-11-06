//
//  MapPathViewController.swift
//  GoogleMap
//
//  Created by Pratik Lad on 05/11/17.
//  Copyright © 2017 Pratik Lad. All rights reserved.
//

import UIKit
import GoogleMaps

class MapPathViewController: UIViewController,GMSMapViewDelegate , MapPathViewModelDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var buttonPlay: UIButton!

    var objMapModel = MapPathViewModel()
    var iTemp:Int = 0
    var marker = GMSMarker()
    var timer = Timer()


    //inially load location on map
    let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 22.857165, longitude: 77.354613, zoom: 4.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetUp()
    }

    func pageSetUp()  {
        
        //Pass view controller delegate on view model page
        objMapModel.delegate = self
        //mapview delegate settings and inial location set
        mapView.delegate = self
        mapView.camera = camera
        
        objMapModel.jsonDataRead()
    }
    
    @IBAction func buttonHandlerPlay(_ sender: Any) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (_) in
            self.playCar()
        })
        buttonPlay.isEnabled = false
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
}

extension MapPathViewController{
    
    //Success json read delegate method
    func isSucessReadJson()  {
        drawPathOnMap()
    }
    
    //fail json read delegate method
    func isFailReadJson(msg : String)  {
        let alert = UIAlertController(title: "Map Alert", message: msg, preferredStyle: .alert)
        let actionOK : UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapPathViewController{
    
    //path create
    func drawPathOnMap()  {
        let path = GMSMutablePath()
        let marker = GMSMarker()
        
        let inialLat:Double = objMapModel.arrayMapPath[0].lat!
        let inialLong:Double = objMapModel.arrayMapPath[0].lon!

        for mapPath in objMapModel.arrayMapPath
        {
            path.add(CLLocationCoordinate2DMake(mapPath.lat!, mapPath.lon!))
        }
        //set poly line on mapview
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 5.0
        marker.map = mapView
        rectangle.map = mapView
        
        //Zoom map with path area
        let loc : CLLocation = CLLocation(latitude: inialLat, longitude: inialLong)
        updateMapFrame(newLocation: loc, zoom: 12.0)
    }
    
    //marker move on map view
    func playCar()
    {
        if iTemp <= (objMapModel.arrayMapPath.count - 1 )
        {
            let iTempMapPath = objMapModel.arrayMapPath[iTemp]
            
            let loc : CLLocation = CLLocation(latitude: iTempMapPath.lat!, longitude: iTempMapPath.lon!)
            
            updateMapFrame(newLocation: loc, zoom: self.mapView.camera.zoom)
            marker.position = CLLocationCoordinate2DMake(iTempMapPath.lat!, iTempMapPath.lon!)
            
            marker.rotation = iTempMapPath.angle!
            
            marker.icon = UIImage(named: "map_car_running.png")
            marker.map = mapView
            
            // Timer close
            if iTemp == (objMapModel.arrayMapPath.count - 1)
            {
                // timer close
                timer.invalidate()
                buttonPlay.isEnabled = true
                iTemp = 0
            }
            iTemp += 1
        }
    }
 
    //Zoom map with cordinate
    func updateMapFrame(newLocation: CLLocation, zoom: Float) {
        let camera = GMSCameraPosition.camera(withTarget: newLocation.coordinate, zoom: zoom)
        self.mapView.animate(to: camera)
    }
    
}
