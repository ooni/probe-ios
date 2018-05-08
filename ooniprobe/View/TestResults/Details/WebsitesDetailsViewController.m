#import "WebsitesDetailsViewController.h"
#import "GRMustache.h"

@interface WebsitesDetailsViewController ()

@end

@implementation WebsitesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.learnCircumventButton setTitle:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Content.LearnToCircumvent", nil) forState:UIControlStateNormal];
    if (super.measurement.blocking == MEASUREMENT_OK){
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
        [self.statusImage setImage:[UIImage imageNamed:@"tick_green"]];
        [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.Reachable.Hero.Title", nil)];
        NSString *subtitle = [GRMustacheTemplate renderObject:@{ @"WebsiteURL": self.measurement.input } fromString:NSLocalizedString(@"TestResults.Details.Websites.Reachable.Content.Paragraph.1", nil) error:NULL];
        [self.subtitleLabel setText:subtitle];
        [self.learnCircumventButton setHidden:YES];
    }
    else if (super.measurement.blocking == MEASUREMENT_BLOCKED){
        Summary *summary = [self.result getSummary];
        [self.statusImage setImage:[UIImage imageNamed:@"x_red"]];
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_red7 alpha:1.0f]];
        [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Hero.Title", nil)];
        NSString *subtitle = [GRMustacheTemplate renderObject:@{ @"WebsiteURL": self.measurement.input, @"BlockingReason": [summary getWebsiteBlocking:self.measurement.input] } fromString:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Content.Paragraph.1", nil) error:NULL];
        [self.subtitleLabel setText:subtitle];
        [self.learnCircumventButton setHidden:NO];
    }
}

- (IBAction)learnCircumvent{
}

@end
