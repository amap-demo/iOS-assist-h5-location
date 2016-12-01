//
//  JavaScriptObj.m
//  assist-h5-location-demo
//
//  Created by eidan on 16/12/1.
//  Copyright © 2016年 autonavi. All rights reserved.
//

#import "JavaScriptObj.h"
#import <UIKit/UIKit.h>

@implementation JavaScriptObj

- (void)showInfoWhenAddMarkerSuccessWithLongitude:(double )longitude andLatitude:(double)latitude{
    
    NSLog(@"js call oc success :%f,%f",longitude,latitude);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"这个提示框是由JS调用OC的函数触发的，在标注点添加成功后调用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert performSelector:@selector(show) withObject:nil afterDelay:3];
}

@end
