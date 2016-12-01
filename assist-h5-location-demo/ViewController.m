//
//  ViewController.m
//  assist-h5-location-demo
//
//  Created by eidan on 16/12/1.
//  Copyright © 2016年 autonavi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //load local html
    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:htmlFilePath]];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
