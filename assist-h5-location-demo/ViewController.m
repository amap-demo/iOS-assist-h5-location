//
//  ViewController.m
//  assist-h5-location-demo
//
//  Created by eidan on 16/12/1.
//  Copyright © 2016年 autonavi. All rights reserved.
//

#import "ViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

#import <JavaScriptCore/JavaScriptCore.h>  //适用于iOS7及以后系统，需添加JavaScriptCore.framework
#import "JavaScriptObj.h"

static const NSString *WebViewKeyPath = @"documentView.webView.mainFrame.javaScriptContext";  //让WebView和JSContext关联
static const NSString *JavaScriptCallOCObj = @"JavaScriptCallOCObj"; //OC暴露给JS的调用类名，例如，在JS文件中通过JavaScriptCallOCObj.functionName,调用OC中的functionName这个函数


@interface ViewController ()<AMapLocationManagerDelegate>

@property (strong, nonatomic) AMapLocationManager *locationManager;

//OC JS 互相调用
@property (strong, nonatomic) JSContext *context;

//xib views
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //load local html
    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:htmlFilePath]];
    
    self.loadingView.hidden = YES;
    
    [self configTheJSContext];
    
    [self configLocationManager];
    
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma -mark 配置WebView

//配置 WebView，让OC和JS可以互调。
- (void)configTheJSContext {
    self.context = [self.webView valueForKeyPath:(NSString *)WebViewKeyPath];
    JavaScriptObj *javaScript = [[JavaScriptObj alloc] init];  //自定义一个类来管理需要被JS调用的函数
    self.context[(NSString *)JavaScriptCallOCObj] = javaScript;
}

//OC调用JS，传入JS的函数名，所需参数依次组成的数组
- (JSValue *)letOCCallJSWithFunName:(NSString *)funName andArguments:(NSArray *)argumentsArray inJSContext:(JSContext *)jsContext {
    JSValue *function = [jsContext objectForKeyedSubscript:funName];
    JSValue *result = [function callWithArguments:argumentsArray];
    return result;
}

#pragma -mark 定位相关

//初始化定位
- (void)configLocationManager {
    
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:5];
    
}

//停止定位，ViewController dealloc 需要调用
- (void)cleanUpAction {
    [self.locationManager stopUpdatingLocation];
}

//进行单次定位请求
- (void)startLocationAction {
    
    [self cleanUpAction];
    
    self.loadingView.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        weakSelf.loadingView.hidden = YES;
        
        if (error) {
            
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            //如果为定位失败的error，则不进行后续操作
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        
        //得到定位信息后，调用JS函数addMarker，需要两个参数，经度和纬度，组成数组传入，其他函数详见map.html
        if (location) {
            [weakSelf letOCCallJSWithFunName:@"addMarker" andArguments:@[[NSNumber numberWithDouble:location.coordinate.longitude],[NSNumber numberWithDouble:location.coordinate.latitude]] inJSContext:weakSelf.context];
        }
    }];
}

#pragma -mark xib btn click

- (IBAction)reUpdatingLocation:(id)sender {
    [self startLocationAction];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
