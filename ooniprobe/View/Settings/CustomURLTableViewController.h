#import <UIKit/UIKit.h>
#import "TestRunningViewController.h"
#import "MessageUtility.h"

@interface CustomURLTableViewController : UITableViewController <UITextFieldDelegate> {
    UIToolbar *keyboardToolbar;
    NSMutableDictionary *urls;
    NSInteger rows;
    NSMutableArray *urlArray;
}

@end
