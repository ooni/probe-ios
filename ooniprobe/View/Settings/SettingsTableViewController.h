#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "UIView+Toast.h"
#import "MessageUtility.h"

@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    NSArray *items;
    UIToolbar *keyboardToolbar;

}

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *testName;

@end
