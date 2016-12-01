//
//  JavaScriptObj.h
//  assist-h5-location-demo
//
//  Created by eidan on 16/12/1.
//  Copyright © 2016年 autonavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptObjExports <JSExport>

JSExportAs(showInfoWhenAddMarkerSuccess, - (void)showInfoWhenAddMarkerSuccessWithLongitude:(double )longitude andLatitude:(double)latitude);

@end

@interface JavaScriptObj : NSObject<JavaScriptObjExports>


@end
