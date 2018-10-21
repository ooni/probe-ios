#import <UIKit/UIKit.h>
#import "ConfigureButton.h"
#import "RunButton.h"
#import "TestRunningViewController.h"
#import "Result.h"
#import "SettingsTableViewController.h"
#import "ReachabilityManager.h"
#import "RHMarkdownLabel.h"
#import "DateTools.h"

@interface TestOverviewViewController : UIViewController {
    UIColor *defaultColor;
    NSDateComponentsFormatter *formatter;
}

@property (nonatomic, strong) NSString *testName;

@property (strong, nonatomic) IBOutlet UIImageView *testImage;
@property (strong, nonatomic) IBOutlet UILabel *testNameLabel;
@property (strong, nonatomic) IBOutlet ConfigureButton *websitesButton;
@property (strong, nonatomic) IBOutlet RunButton *runButton;
@property (strong, nonatomic) IBOutlet UILabel *testDetailLabel;
@property (strong, nonatomic) IBOutlet RHMarkdownLabel *testDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end
