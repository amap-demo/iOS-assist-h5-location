//
//  ViewController.swift
//  assist-h5-location-demo-swift
//
//  Created by eidan on 17/1/9.
//  Copyright © 2017年 autonavi. All rights reserved.
//

import UIKit
import JavaScriptCore


class ViewController: UIViewController,AMapLocationManagerDelegate,UIWebViewDelegate {
    
    let WebViewKeyPath = "documentView.webView.mainFrame.javaScriptContext"  //让WebView和JSContext关联
    let JavaScriptCallNativeObj = "JavaScriptCallNativeObj"  //Swift暴露给JS的调用类名，例如，在JS文件中通过JavaScriptCallNativeObj.functionName,调用Swift中的functionName这个函数
    
    var locationManager : AMapLocationManager!
    var context : JSContext!  //swift JS 互相调用
    
    //xib views
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load local html
        let htmlFilePath = Bundle.main.path(forResource: "map", ofType: "html")
        let htmlStr : String = try! NSString(contentsOfFile: htmlFilePath!, encoding: String.Encoding.utf8.rawValue) as String
        self.webView.loadHTMLString(htmlStr, baseURL: NSURL(fileURLWithPath: htmlFilePath!) as URL)
        
        //两种load local html都可以
//        let url = Bundle.main.url(forResource: "map", withExtension: "html")
//        let request = URLRequest(url: url!)
//        self.webView.loadRequest(request)
        
        self.loadingView.isHidden = true
        
        self.configTheJSContext()
        
        self.configLocationManager()
        
    }
    
    //配置 WebView，让Swift和JS可以互调。
    func configTheJSContext() {
        self.context = self.webView.value(forKeyPath: WebViewKeyPath) as! JSContext!
        let javaScriptObj : JavaScriptObjInSwift = JavaScriptObjInSwift()
        self.context.setObject(javaScriptObj, forKeyedSubscript: JavaScriptCallNativeObj as (NSCopying & NSObjectProtocol)!)
    }
    
    //Swift调用JS，传入JS的函数名，所需参数依次组成的数组
    func letNativeCallJS(with funName : String, argumentsArray : Array<Any>, in jsContext : JSContext) -> JSValue {
        let function : JSValue = jsContext.objectForKeyedSubscript(funName)
        let result : JSValue = function.call(withArguments: argumentsArray)
        return result
    }
    
    //初始化定位
    func configLocationManager() {
        self.locationManager = AMapLocationManager.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.locationTimeout = 5
    }
    
    //停止定位，ViewController dealloc 需要调用
    func cleanUpAction() {
        self.locationManager.stopUpdatingLocation()
    }
    
    //进行单次定位请求
    func startLocationAction() {
        
        self.cleanUpAction()
        self.loadingView.isHidden = false
        
        self.locationManager.requestLocation(withReGeocode: false) { [weak self] (location: CLLocation?, regeocode: AMapLocationReGeocode?, error: Error?) in
            
            self?.loadingView.isHidden = true
            
            if let error = error {
                let error = error as NSError
                print("locError:{\(error.code) - \(error.localizedDescription)};")
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    return;
                }
            }
            
            //得到定位信息后，调用JS函数addMarker，需要两个参数，经度和纬度，组成数组传入，其他函数详见map.html
            if location != nil {
               _ =  self?.letNativeCallJS(with: "addMarker", argumentsArray: [location?.coordinate.longitude as Any,location?.coordinate.latitude as Any], in: (self?.context)!)
            }
            
        }
        
    }
 
    // MARK - xib btn click
    @IBAction func reUpdatingLocation(_ sender: Any) {
        self.startLocationAction()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

