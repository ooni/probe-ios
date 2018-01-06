#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "UIView+Toast.h"

@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    NSArray *items;
    UIToolbar *keyboardToolbar;
}

@property (nonatomic, strong) NSString *category;

@end
