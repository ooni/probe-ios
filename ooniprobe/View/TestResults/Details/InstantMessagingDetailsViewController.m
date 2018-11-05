#import "InstantMessagingDetailsViewController.h"

@interface InstantMessagingDetailsViewController ()

@end

@implementation InstantMessagingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TestKeys *testKeys = [self.measurement testKeysObj];
    [self.statusImage setTintColor:[UIColor whiteColor]];

    if (!super.measurement.is_anomaly){
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
        [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
    }
    else {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
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
        [self.detail3TitleLabel setText:@" "];
        [self.detail3SubtitleLabel setText:@" "];
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Reachable.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Reachable.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.LikelyBlocked.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Reachable.LikelyBlocked.Paragraph", nil)];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Application.Label.Title", nil)];
        [self.detail2TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.WebApp.Label.Title", nil)];
        [self.detail1SubtitleLabel setText:[testKeys getTelegramEndpointStatus]];
        [self.detail1SubtitleLabel setTextColor:[testKeys getTelegramEndpointStatusColor]];
        [self.detail2SubtitleLabel setText:[testKeys getTelegramWebStatus]];
        [self.detail2SubtitleLabel setTextColor:[testKeys getTelegramWebStatusColor]];
    }
    else if ([self.measurement.test_name isEqualToString:@"facebook_messenger"]){
        [self.detail3TitleLabel setText:@" "];
        [self.detail3SubtitleLabel setText:@" "];
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
}

@end
