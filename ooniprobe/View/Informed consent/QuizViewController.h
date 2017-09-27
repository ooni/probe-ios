#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "RoundedButton.h"

@interface QuizViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *firstQuestion;
    NSArray *secondQuestion;
    NSArray *headers;
    long firstAnswer;
    long secondAnswer;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet RoundedButton *nextButton;


@end
