#import <UIKit/UIKit.h>
#import "SettingsTableViewController.h"
#import "TestRunningViewController.h"
#import "RunButton.h"
#import "ConfigureButton.h"
#import "TestOverviewViewController.h"
#import "ReachabilityManager.h"

@interface DashboardTableViewController : UITableViewController {
    NSArray *items;
    NSDateComponentsFormatter *formatter;
}

@end
