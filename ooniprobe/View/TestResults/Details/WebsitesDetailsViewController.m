#import "WebsitesDetailsViewController.h"

@interface WebsitesDetailsViewController ()

@end

@implementation WebsitesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.learnCircumventButton setTitle:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Content.LearnToCircumvent", nil) forState:UIControlStateNormal];
    if (super.measurement.blocking == MEASUREMENT_OK){
        [self.statusImage setImage:[UIImage imageNamed:@"tick_green"]];
        [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.Reachable.Hero.Title", nil)];
        [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.Reachable.Content.Paragraph.1", nil)];
        [self.learnCircumventButton setHidden:YES];
    }
    else if (super.measurement.blocking == MEASUREMENT_BLOCKED){
        [self.statusImage setImage:[UIImage imageNamed:@"tick_red"]];
        [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Hero.Title", nil)];
        [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Content.Paragraph.1", nil)];
        [self.learnCircumventButton setHidden:NO];
    }
}

- (IBAction)learnCircumvent{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
