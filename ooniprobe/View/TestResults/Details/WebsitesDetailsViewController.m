#import "WebsitesDetailsViewController.h"

@interface WebsitesDetailsViewController ()

@end

@implementation WebsitesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.learnCircumventButton setTitle:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Content.LearnToCircumvent", nil) forState:UIControlStateNormal];
    if (!super.measurement.is_anomaly){
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
        [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];

        [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.Reachable.Hero.Title", nil)];
        NSString *subtitle = NSLocalizedFormatString(@"TestResults.Details.Websites.Reachable.Content.Paragraph.1", self.measurement.url_id.url);
        [self.subtitleLabel setText:subtitle];
        [self.learnCircumventButton setHidden:YES];
    }
    else {
        TestKeys *testKeys = [self.measurement testKeysObj];
        [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_yellow8 alpha:1.0f]];
        [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Hero.Title", nil)];
        NSString *subtitle = NSLocalizedFormatString(@"TestResults.Details.Websites.LikelyBlocked.Content.Paragraph.1", [testKeys getWebsiteBlocking]);
        [self.subtitleLabel setText:subtitle];
        [self.learnCircumventButton setHidden:NO];
    }
}

- (IBAction)learnCircumvent{
}

@end
