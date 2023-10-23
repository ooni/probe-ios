#import "InstantMessagingDetailsViewController.h"
#import "RunningTest.h"

@interface InstantMessagingDetailsViewController ()

@end

@implementation InstantMessagingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TestKeys *testKeys = [self.measurement testKeysObj];
    [self.textLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self reloadConstraints];

    if (!super.measurement.is_anomaly){
        [self.headerView setBackgroundColor:[UIColor colorNamed:@"color_green7"]];
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
    }
    else {
        [self.headerView setBackgroundColor:[UIColor colorNamed:@"color_yellow9"]];
        [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
    }
    
    if ([self.measurement.test_name isEqualToString:@"whatsapp"]){
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Reachable.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Reachable.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.LikelyBlocked.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.LikelyBlocked.Content.Paragraph", nil)];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Title", nil)];
        [self.detail2TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.WebApp.Label.Title", nil)];
        [self.detail3TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Registrations.Label.Title", nil)];
        [self.detail1SubtitleLabel setText:[testKeys getWhatsappEndpointStatus]];
        [self.detail1SubtitleLabel setTextColor:[testKeys getWhatsappEndpointStatusColor]];
        [self.detail2SubtitleLabel setText:[testKeys getWhatsappWebStatus]];
        [self.detail2SubtitleLabel setTextColor:[testKeys getWhatsappWebStatusColor]];
        [self.detail3SubtitleLabel setText:[testKeys getWhatsappRegistrationStatus]];
        [self.detail3SubtitleLabel setTextColor:[testKeys getWhatsappRegistrationStatusColor]];
    }
    else if ([self.measurement.test_name isEqualToString:@"telegram"]){
        [self.detail3TitleLabel setText:@""];
        [self.detail3SubtitleLabel setText:@""];
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Reachable.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Reachable.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.LikelyBlocked.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.LikelyBlocked.Content.Paragraph", nil)];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Application.Label.Title", nil)];
        [self.detail2TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.WebApp.Label.Title", nil)];
        [self.detail1SubtitleLabel setText:[testKeys getTelegramEndpointStatus]];
        [self.detail1SubtitleLabel setTextColor:[testKeys getTelegramEndpointStatusColor]];
        [self.detail2SubtitleLabel setText:[testKeys getTelegramWebStatus]];
        [self.detail2SubtitleLabel setTextColor:[testKeys getTelegramWebStatusColor]];
    }
    else if ([self.measurement.test_name isEqualToString:@"facebook_messenger"]){
        [self.detail3TitleLabel setText:@""];
        [self.detail3SubtitleLabel setText:@""];
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.Reachable.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.Reachable.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.LikelyBlocked.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.LikelyBlocked.Content.Paragraph", nil)];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.TCP.Label.Title", nil)];
        [self.detail2TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.DNS.Label.Title", nil)];
        [self.detail1SubtitleLabel setText:[testKeys getFacebookMessengerTcp]];
        [self.detail1SubtitleLabel setTextColor:[testKeys getFacebookMessengerTcpColor]];
        [self.detail2SubtitleLabel setText:[testKeys getFacebookMessengerDns]];
        [self.detail2SubtitleLabel setTextColor:[testKeys getFacebookMessengerDnsColor]];
    }
    else if ([self.measurement.test_name isEqualToString:@"signal"]){
        [self.detail1TitleLabel setText:@""];
        [self.detail1SubtitleLabel setText:@""];
        [self.detail2TitleLabel setText:@""];
        [self.detail2SubtitleLabel setText:@""];
        [self.detail3TitleLabel setText:@""];
        [self.detail3SubtitleLabel setText:@""];
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Signal.Reachable.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Signal.Reachable.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Signal.LikelyBlocked.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Signal.LikelyBlocked.Content.Paragraph", nil)];
        }
    }
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
