//
//  MyOverlayView.swift
//  MapAnimCover
//
//  Created by 卢大维 on 15/1/28.
//  Copyright (c) 2015年 weather. All rights reserved.
//

import UIKit
import MapKit

class MyOverlayView: MKOverlayRenderer {
    
    var image:UIImage?
    
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext!) {
        
        let theMapRect    = self.overlay.boundingMapRect
        let theRect       = self.rectForMapRect(theMapRect)
        
        UIGraphicsPushContext(context)
        
        if let image = self.image {
            image.drawInRect(theRect, blendMode: kCGBlendModeCopy, alpha: self.alpha)
        }
        
        UIGraphicsPopContext()
    }
}
