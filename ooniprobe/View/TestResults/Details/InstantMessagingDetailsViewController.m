#import "InstantMessagingDetailsViewController.h"
#import "GRMustache.h"

@interface InstantMessagingDetailsViewController ()

@end

@implementation InstantMessagingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Summary *summary = [self.result getSummary];

    if (super.measurement.blocking == MEASUREMENT_OK){
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
        [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
    }
    else {
        [self.statusImage setImage:[UIImage imageNamed:@"cross"]];
        [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_red7 alpha:1.0f]];
    }
    
    if ([self.measurement.name isEqualToString:@"whatsapp"]){
        if (super.measurement.blocking == MEASUREMENT_OK){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Reachable.Hero.Title", nil)];
            [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Reachable.Content.Paragraph.1", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.LikelyBlocked.Hero.Title", nil)];
            [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.LikelyBlocked.Content.Paragraph.1", nil)];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Title", nil)];
        [self.detail2TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.WebApp.Label.Title", nil)];
        [self.detail3TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Registrations.Label.Title", nil)];
        [self.detail1SubtitleLabel setText:[summary getWhatsappEndpointStatus]];
        [self.detail2SubtitleLabel setText:[summary getWhatsappWebStatus]];
        [self.detail3SubtitleLabel setText:[summary getWhatsappRegistrationStatus]];
    }
    else if ([self.measurement.name isEqualToString:@"telegram"]){
        [self.detail3View setHidden:YES];
        if (super.measurement.blocking == MEASUREMENT_OK){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Reachable.Hero.Title", nil)];
            [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Reachable.Content.Paragraph.1", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.LikelyBlocked.Hero.Title", nil)];
            NSString *subtitle = [GRMustacheTemplate renderObject:@{ @"BlockingReason": [summary getTelegramBlocking] } fromString:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.LikelyBlocked.Content.Paragraph.1", nil) error:NULL];
            [self.subtitleLabel setText:subtitle];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Application.Label.Title", nil)];
        [self.detail2TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.WebApp.Label.Title", nil)];
        [self.detail1SubtitleLabel setText:[summary getTelegramEndpointStatus]];
        [self.detail2SubtitleLabel setText:[summary getTelegramWebStatus]];
    }
    else if ([self.measurement.name isEqualToString:@"facebook_messenger"]){
        [self.detail3View setHidden:YES];
        if (super.measurement.blocking == MEASUREMENT_OK){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.Reachable.Hero.Title", nil)];
            [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.Reachable.Content.Paragraph.1", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.LikelyBlocked.Hero.Title", nil)];
            NSString *subtitle = [GRMustacheTemplate renderObject:@{ @"BlockingReason": [summary getFacebookMessengerBlocking] } fromString:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.LikelyBlocked.Content.Paragraph.1", nil) error:NULL];
            [self.subtitleLabel setText:subtitle];
        }
        [self.detail1TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.TCP.Label.Title", nil)];
        [self.detail2TitleLabel setText:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.DNS.Label.Title", nil)];
        [self.detail1SubtitleLabel setText:[summary getFacebookMessengerTcp]];
        [self.detail2SubtitleLabel setText:[summary getFacebookMessengerDns]];
    }

}

@end
