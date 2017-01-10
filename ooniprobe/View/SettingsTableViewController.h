// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate> {
    NSArray *settingsItems;
    NSArray *otherItems;
    UITextField *value;
    UIDatePicker *datePicker;
    NSDateFormatter *dateFormatter;
    UITextField *timeField;
    UIToolbar *keyboardToolbar;
}

@end
