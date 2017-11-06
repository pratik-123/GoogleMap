//
//  MapPath.swift
//  GoogleMap
//
//  Created by Pratik Lad on 05/11/17.
//  Copyright © 2017 Pratik Lad. All rights reserved.
//

class MapPath {
    
    var lat : Double?
    var lon : Double?
    var angle : Double?
   
    init() {}
    init(lat : Double?,lon : Double?,angle : Double?) {
        self.lat = lat
        self.lon = lon
        self.angle = angle
    }
}
