#import "FailedTestDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ReachabilityManager.h"

@interface FailedTestDetailsViewController ()

@end

@implementation FailedTestDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:self.measurement.url_id.url];
    [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                    color:[UIColor colorNamed:@"color_gray8"]];
    [self.headerView setBackgroundColor:[UIColor colorNamed:@"color_gray8"]];
    [self.statusImage setImage:[UIImage imageNamed:@"error"]];
    [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Failed.Title", nil)];
    [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Failed.Paragraph", nil)];
    [self.tryAgainButton setTitle:NSLocalizedString(@"TestResults.Details.Failed.TryAgain", nil) forState:UIControlStateNormal];
    self.tryAgainButton.layer.cornerRadius = self.tryAgainButton.bounds.size.height/2;
    self.tryAgainButton.layer.masksToBounds = YES;
    self.tryAgainButton.layer.borderWidth = 0.5f;
    self.tryAgainButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(IBAction)reRun{
    if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable)
        [self performSegueWithIdentifier:@"toTestRun" sender:self];
    else
        [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.Error", nil) message:NSLocalizedString(@"Modal.Error.NoInternet", nil) inView:self];
}

@end
