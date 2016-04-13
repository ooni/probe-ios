//
//  ViewController.h
//  NetProbe
//
//  Created by Simone Basso on 18/01/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogViewController.h"
#import "NetworkManager.h"
#import "TestInfoViewController.h"

@interface ViewController : UIViewController

@property NSMutableArray *availableNetworkMeasurements;

@property (strong, nonatomic) IBOutlet UILabel *testing_historyLabel;
@property (strong, nonatomic) IBOutlet UILabel *pending_testsLabel;
@property (strong, nonatomic) IBOutlet UILabel *run_testLabel;

@property (strong, nonatomic) IBOutlet UILabel *dns_injectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *tcp_connectLabel;
@property (strong, nonatomic) IBOutlet UILabel *http_invalid_request_lineLabel;

@property (strong, nonatomic) IBOutlet UIButton *dns_injectionButton;
@property (strong, nonatomic) IBOutlet UIButton *tcp_connectButton;
@property (strong, nonatomic) IBOutlet UIButton *http_invalid_request_lineButton;

@property (strong, nonatomic) IBOutlet UIButton *runButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NetworkManager *manager;

@property (strong, nonatomic) NetworkMeasurement *selectedMeasurement;

@end