//
//  ViewController.swift
//  TestMapCover
//
//  Created by 卢大维 on 15/1/28.
//  Copyright (c) 2015年 weather. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MAMapViewDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {

    
    var type:Int? = 0
    
    var mapView:AnyObject?
    var icon:UIImage?
    
    var FLAG:Bool = false
    
//    override init() {
//        super.init()
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.navigationController?.navigationBarHidden = true
//        self.navigationController?.interactivePopGestureRecognizer.delegate = self
        
        
        if FLAG {
            var mapView = MAMapView()
            mapView.delegate = self
            self.view.addSubview(mapView)
            mapView.mas_makeConstraints { (make) -> Void in()
                make.edges.mas_equalTo()(self.view)
            }
            
            self.mapView = mapView
        }
        else
        {
            var mapView = MKMapView()
            mapView.delegate = self
            self.view.addSubview(mapView)
            mapView.mas_makeConstraints { (make) -> Void in()
                make.edges.mas_equalTo()(self.view)
            }
            
            self.mapView = mapView
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var modify = 0.0
        
        if FLAG {
            modify = 5.0
        }
        
        var coor:MACoordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake(80, -180), CLLocationCoordinate2DMake(-82.0829, 179.804))
        if (type != nil) {
            if type == 1 {
                self.title = "温度"
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(80.9437+modify, -180), CLLocationCoordinate2DMake(-82.0829+modify, 179.804))
                
                icon = UIImage(named: "温度14122008.000.png")!
            }
            else if type == 2
            {
                self.title = "相对湿度"
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(80.9437+modify, -180), CLLocationCoordinate2DMake(-82.0829+modify, 179.804))
                
                icon = UIImage(named: "相对湿度14122008.000n.png")!
            }
            else if type == 3 {
                self.title = "霾预报"
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(60+modify, 70), CLLocationCoordinate2DMake(-0.046501+modify, 150.053))
                
                icon = UIImage(named: "霾预报haze092608.024-webmoctor.png")!
            }
            else if type == 4 {
                self.title = "空气污染预报"
                
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(60+modify, 70), CLLocationCoordinate2DMake(-0.046501+modify, 150))
                
                icon = UIImage(named: "空气污染预报kw15011920.024-webmoctor.png")!
            }
            else if type == 5 {
                self.title = "24小时变温15012114.000"
                
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(60+modify, 70), CLLocationCoordinate2DMake(-0.046501+modify, 150.053))
                
                icon = UIImage(named: "24小时变温15012114.000.png")!
            }
            else if type == 6 {
                self.title = "大风降温预报13101508.024"
                
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(60+modify, 70), CLLocationCoordinate2DMake(-0.046501+modify, 150.053))
                
                icon = UIImage(named: "大风降温预报13101508.024.png")!
            }
            else if type == 7 {
                self.title = "强降雪落区预报14120108.024"
                
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(60+modify, 70), CLLocationCoordinate2DMake(-0.046501+modify, 150.053))
                
                icon = UIImage(named: "强降雪落区预报14120108.024.png")!
            }
            else if type == 8 {
                self.title = "24小时降雨量15012108.000"
                
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(60+modify, 70), CLLocationCoordinate2DMake(-0.046501+modify, 150.053))
                
                icon = UIImage(named: "24小时降雨量15012108.000.png")!
//                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(60, 70), CLLocationCoordinate2DMake(-0.0346611, 150.054))
//                
//                icon = UIImage(named: "15012108.000.png")!
            }
            else if type == 9 {
                self.title = "云图1"
                
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(61.5+modify, 60), CLLocationCoordinate2DMake(6.0+modify, 145.0))
                
                icon = UIImage(named: "20150302170000.PNG")!
            }
            else if type == 10 {
                self.title = "云图2"
                
                coor = MACoordinateBoundsMake(CLLocationCoordinate2DMake(50.02+modify, 59.97), CLLocationCoordinate2DMake(-4.98+modify, 144.97))
                
                icon = UIImage(named: "IR_CLOUD_FY2F_201503021700_WEBMECTOR_X2.png")!
            }
            
        }
        if FLAG {
            var overlay = MAGroundOverlay(bounds: coor, icon: icon)
            
            let mapView:MAMapView = self.mapView as MAMapView
            mapView.addOverlay(overlay)
            mapView.visibleMapRect = overlay.boundingMapRect;
            
            if (type == 9 || type == 10){
                mapView.mapType = UInt(MAMapTypeSatellite)
            }
        }
        else
        {
            let overlay:MyOverlay = MyOverlay(northEast: coor.northEast, southWest: coor.southWest)
            
            let mapView:MKMapView = self.mapView as MKMapView
            mapView.addOverlay(overlay)
            mapView.visibleMapRect = overlay.boundingMapRect;
            
            if (type == 9 || type == 10){
                mapView.mapType = .Hybrid
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MAMapView!, viewForOverlay overlay: MAOverlay!) -> MAOverlayView! {
        if overlay.isKindOfClass(MAGroundOverlay){
            let view = MAGroundOverlayView(groundOverlay: overlay as MAGroundOverlay!)
            if (type == 9 || type == 10){
                view.alpha = 0.85
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay.isKindOfClass(MyOverlay)
        {
            let overlayView = MyOverlayView(overlay: overlay)
            overlayView.image = icon
            if (type == 9 || type == 10) {
                overlayView.alpha = 0.85
            }
            
            return overlayView
        }
        return nil
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if FLAG {
            let mapView:MAMapView = self.mapView as MAMapView
            mapView.delegate = nil
        }
        else
        {
            let mapView:MKMapView = self.mapView as MKMapView
            mapView.delegate = nil
        }
    }
    
}

