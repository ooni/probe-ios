#import "WebsitesDetailsViewController.h"
#import "GRMustache.h"

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
        NSString *subtitle = [GRMustacheTemplate renderObject:@{ @"WebsiteURL": self.measurement.url_id.url } fromString:NSLocalizedString(@"TestResults.Details.Websites.Reachable.Content.Paragraph.1", nil) error:NULL];
        [self.subtitleLabel setText:subtitle];
        [self.learnCircumventButton setHidden:YES];
    }
    else {
        TestKeys *testKeys = [self.measurement testKeysObj];
        [self.statusImage setImage:[UIImage imageNamed:@"cross"]];
        [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_red7 alpha:1.0f]];
        [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Hero.Title", nil)];
        NSString *subtitle = [GRMustacheTemplate renderObject:@{ @"WebsiteURL": self.measurement.url_id.url, @"BlockingReason": [testKeys getWebsiteBlocking] } fromString:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Content.Paragraph.1", nil) error:NULL];
        [self.subtitleLabel setText:subtitle];
        [self.learnCircumventButton setHidden:NO];
    }
}

- (IBAction)learnCircumvent{
}

@end
