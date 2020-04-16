#import "WebsitesDetailsViewController.h"

@interface WebsitesDetailsViewController ()

@end

@implementation WebsitesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:self.measurement.url_id.url];
    [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    if (!super.measurement.is_anomaly){
        [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
        [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.Reachable.Hero.Title", nil)];
        NSString *paragraph = NSLocalizedFormatString(@"TestResults.Details.Websites.Reachable.Content.Paragraph", [NSString stringWithFormat:@"`%@`", self.measurement.url_id.url]);
        [self.textLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:14]];
        [self.textLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        [self.textLabel setMarkdown:paragraph];
        [self.textLabel setDidSelectLinkWithURLBlock:^(RHMarkdownLabel *label, NSURL *url) {
            [[UIApplication sharedApplication] openURL:url];
        }];
    }
    else {
        TestKeys *testKeys = [self.measurement testKeysObj];
        [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
        [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Hero.Title", nil)];
        NSString *paragraph = NSLocalizedFormatString(@"TestResults.Details.Websites.LikelyBlocked.Content.Paragraph", [NSString stringWithFormat:@"`%@`", self.measurement.url_id.url], [testKeys getWebsiteBlocking]);
        [self.textLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:14]];
        [self.textLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        [self.textLabel setMarkdown:paragraph];
        [self.textLabel setDidSelectLinkWithURLBlock:^(RHMarkdownLabel *label, NSURL *url) {
            [[UIApplication sharedApplication] openURL:url];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!super.measurement.is_anomaly){
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
    }
    else {
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
    }
}

@end
