//
//  MyTableController.swift
//  TestMapCover
//
//  Created by 卢大维 on 15/1/28.
//  Copyright (c) 2015年 weather. All rights reserved.
//

import UIKit

class MyTableController: UITableViewController {
    
    var FLAG:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
//            self.navigationController?.interactivePopGestureRecognizer.delegate = nil;
//        }
        self.tableView.rowHeight = 44;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "apple", style: UIBarButtonItemStyle.Done, target: self, action: "clickRightButton")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "testMap", style: UIBarButtonItemStyle.Done, target: self, action: "clickLeftButton")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier:String? = segue.identifier
        let v:ViewController = segue.destinationViewController as ViewController
        v.FLAG = self.FLAG
        v.type = identifier?.toInt()
    }
    
    func clickRightButton() {
        
        self.navigationItem.rightBarButtonItem?.title = (self.navigationItem.rightBarButtonItem?.title == "apple") ? "高德":"apple"
        
        self.FLAG = (self.navigationItem.rightBarButtonItem?.title != "apple")
    }
    
    func clickLeftButton()
    {
        self.navigationController?.pushViewController(MapViewController1(), animated: true)
    }

}
