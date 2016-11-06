// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface QuizViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *firstQuestion;
    NSArray *secondQuestion;
    NSArray *headers;
    long firstAnswer;
    long secondAnswer;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;


@end
