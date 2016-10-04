//
//  ConfigurationViewController.h
//  NetProbe
//
//  Created by Lorenzo Primiterra on 16/09/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface ConfigurationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *settingsTitles;
    NSArray *settingsItems;
    NSMutableArray *settingsValues;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
