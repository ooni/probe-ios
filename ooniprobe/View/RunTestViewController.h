//
//  RunTestTableViewController.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 06/08/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tests.h"

@interface RunTestViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NetworkMeasurement *currentTest;
    NSArray *urls;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *test_detailsLabel;
@property (nonatomic, retain) IBOutlet UILabel *test_titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *test_iconImage;

@property (nonatomic, retain) NSString *test_name;
@property (nonatomic, retain) NSDictionary *test_arguments;
@property (nonatomic, retain) NSString *test_decription;

@end
