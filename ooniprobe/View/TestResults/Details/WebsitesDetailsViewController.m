#import "WebsitesDetailsViewController.h"
#import "RunningTest.h"

@interface WebsitesDetailsViewController ()

@end

@implementation WebsitesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:self.measurement.url_id.url];
    if (!super.measurement.is_anomaly){
        [self.headerView setBackgroundColor:[UIColor colorNamed:@"color_green7"]];
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
        [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.Reachable.Hero.Title", nil)];
        NSString *paragraph = NSLocalizedFormatString(@"TestResults.Details.Websites.Reachable.Content.Paragraph", [NSString stringWithFormat:@"`%@`", self.measurement.url_id.url]);
        [self.textLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:14]];
        [self.textLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self.textLabel setMarkdown:paragraph];
        [self.textLabel setDidSelectLinkWithURLBlock:^(RHMarkdownLabel *label, NSURL *url) {
            [[UIApplication sharedApplication] openURL:url];
        }];
    }
    else {
        TestKeys *testKeys = [self.measurement testKeysObj];
        [self.headerView setBackgroundColor:[UIColor colorNamed:@"color_yellow9"]];
        [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
        [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Hero.Title", nil)];
        NSString *paragraph = NSLocalizedFormatString(@"TestResults.Details.Websites.LikelyBlocked.Content.Paragraph", [NSString stringWithFormat:@"`%@`", self.measurement.url_id.url], [testKeys getWebsiteBlocking]);
        [self.textLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:14]];
        [self.textLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
        [linkAttributes setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [linkAttributes setObject:[UIColor colorNamed:@"color_base"] forKey:(NSString *)kCTForegroundColorAttributeName];
        self.textLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:linkAttributes];
        [self.textLabel setMarkdown:paragraph];
        [self.textLabel setDidSelectLinkWithURLBlock:^(RHMarkdownLabel *label, NSURL *url) {
            [[UIApplication sharedApplication] openURL:url];
        }];
    }
    [self reloadConstraints];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadConstraints];
    if (!super.measurement.is_anomaly){
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorNamed:@"color_green7"]];
    }
    else {
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[UIColor colorNamed:@"color_yellow9"]];
    }
}

-(void)reloadConstraints{
    CGFloat uploadConstraint = 64;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.uploadBarFooterConstraint.constant = uploadConstraint;
    });
}

@end
