#import <UIKit/UIKit.h>
#import "TestRunningViewController.h"
#import "MessageUtility.h"
#import "RunButton.h"

@interface CustomURLViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIToolbar *keyboardToolbar;
    NSMutableArray *urlArray;
}

@property (strong, nonatomic) NSMutableArray *urlsList;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet RunButton *runButton;
@property (strong, nonatomic) IBOutlet RunButton *loadFromTemplateButton;

@end
