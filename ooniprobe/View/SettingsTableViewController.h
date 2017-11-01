#import <UIKit/UIKit.h>
#import "PBRevealViewController.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
#import "TestStorage.h"
#import "UIBarButtonItem+Badge.h"

@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {
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
