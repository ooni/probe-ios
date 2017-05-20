// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import "PBRevealViewController.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"

@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate> {
    NSArray *privacyItems;
    NSArray *notificationItems;
    NSArray *advancedItems;
    UITextField *value;
    UIDatePicker *datePicker;
    NSDateFormatter *dateFormatter;
    UITextField *timeField;
    UIToolbar *keyboardToolbar;
}

@end
