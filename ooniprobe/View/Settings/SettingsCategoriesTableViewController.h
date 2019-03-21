#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "SettingsTableViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingsCategoriesTableViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
    NSArray *categories;
}

@end
