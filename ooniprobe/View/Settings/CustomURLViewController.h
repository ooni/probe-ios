#import <UIKit/UIKit.h>
#import "TestRunningViewController.h"
#import "MessageUtility.h"

@interface CustomURLViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIToolbar *keyboardToolbar;
    NSMutableArray *urls;
    NSMutableArray *urlArray;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *runButton;

@end
