//
//  assist_h5_location_demoUITests.m
//  assist-h5-location-demoUITests
//
//  Created by eidan on 17/1/9.
//  Copyright © 2017年 autonavi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAMapUITestHelper.h"

@interface assist_h5_location_demoUITests : XCTestCase

@end

@implementation assist_h5_location_demoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    sleep(2);
    
    [app.buttons[@"\u5f00\u59cb\u5b9a\u4f4d"] tap];
    
    XCUIElement *alert = app.alerts[@"这个提示框是由JS调用OC的函数触发的，在标注点添加成功后调用"];
    
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == YES"];
    
    [self expectationForPredicate:exists evaluatedWithObject:alert handler:^BOOL{
        
        [alert.buttons[@"确定"] tap];
        return YES;
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
    
    
    XCTestExpectation *e = [self expectationWithDescription:@"empty wait"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [e fulfill];
    });
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
}

@end
