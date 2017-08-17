//
//  RunTestTableViewController.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 06/08/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tests.h"
#import "RoundedButton.h"
#import "UIView+Toast.h"

@interface RunTestViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    Tests *currentTests;
    NSArray *urls;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *test_detailsLabel;
@property (nonatomic, retain) IBOutlet UILabel *test_titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *test_iconImage;
@property (nonatomic, strong) IBOutlet RoundedButton *runButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, retain) NSString *testName;
@property (nonatomic, retain) NSDictionary *testArguments;
@property (nonatomic, retain) NSString *testDecription;

@end
