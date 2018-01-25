#import <UIKit/UIKit.h>
#import "ConfigureButton.h"
#import "RunButton.h"
#import "TestRunningViewController.h"

@interface TestOverviewViewController : UIViewController {
    UIColor *defaultColor;
}

@property (nonatomic, strong) NSString *testName;

@property (strong, nonatomic) IBOutlet UIImageView *testImage;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *testNameLabel;
@property (strong, nonatomic) IBOutlet ConfigureButton *configureButton;
@property (strong, nonatomic) IBOutlet RunButton *runButton;
@property (strong, nonatomic) IBOutlet UILabel *lastRunLabel;
@property (strong, nonatomic) IBOutlet UILabel *testDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end
