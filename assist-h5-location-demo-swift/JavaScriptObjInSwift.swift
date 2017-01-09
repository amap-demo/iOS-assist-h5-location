//
//  JavaScriptObjInSwift.swift
//  assist-h5-location-demo
//
//  Created by eidan on 17/1/9.
//  Copyright © 2017年 autonavi. All rights reserved.
//


import UIKit
import JavaScriptCore

@objc protocol JavaScriptObjExports: JSExport {
    
    func showInfoWhenAddMarkerSuccess()
    
}

@objc class JavaScriptObjInSwift: NSObject ,JavaScriptObjExports {
    
    func showInfoWhenAddMarkerSuccess() {
        print("JS call Swift success")
        let alertView = UIAlertView.init(title: "这个提示框是由JS调用Swift的函数触发的，在标注点添加成功后调用", message: nil, delegate: nil, cancelButtonTitle: "确定")
        alertView.perform(#selector(UIAlertView.show), with: nil, afterDelay: 2)
    }
    
}
