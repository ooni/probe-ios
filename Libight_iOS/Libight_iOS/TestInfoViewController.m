//
//  TestInfoViewController.m
//  Libight_iOS
//
//  Created by Lorenzo Primiterra on 14/04/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import "TestInfoViewController.h"

@interface TestInfoViewController ()

@end

@implementation TestInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *pathToHtml = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"html"];
    NSString *htmlData = [NSString stringWithContentsOfFile:pathToHtml encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:htmlData baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
