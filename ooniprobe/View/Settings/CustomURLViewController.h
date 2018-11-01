#import <UIKit/UIKit.h>
#import "TestRunningViewController.h"
#import "MessageUtility.h"
#import "RunButton.h"
#import "AppDelegate.h"

@interface CustomURLViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIToolbar *keyboardToolbar;
    AppDelegate *delegate;
    NSMutableArray *urlArray;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet RunButton *runButton;

@end
