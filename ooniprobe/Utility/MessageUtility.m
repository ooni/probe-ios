#import "MessageUtility.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "Countly.h"
#import "SettingsUtility.h"

@implementation MessageUtility

+ (void)showToast:(NSString*)msg inView:(UIView*)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [view makeToast:msg];
    });
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg inView:(UIViewController *)view
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                               style:UIAlertActionStyleDefault
                               handler:nil];
    [alert addAction:okButton];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view presentViewController:alert animated:YES completion:nil];
    });
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg okButton:(UIAlertAction*)okButton inView:(UIViewController *)view
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Modal.Cancel", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [alert addAction:cancelButton];
    [alert addAction:okButton];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view presentViewController:alert animated:YES completion:nil];
    });
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg buttons:(NSArray*)buttons inView:(UIViewController *)view
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Modal.Cancel", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [alert addAction:cancelButton];
    for (UIAlertAction* button in buttons)
        [alert addAction:button];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view presentViewController:alert animated:YES completion:nil];
    });
}


+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg okButton:(UIAlertAction*)okButton cancelButton:(UIAlertAction*)cancelButton inView:(UIViewController *)view
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    if (cancelButton != nil)
        [alert addAction:cancelButton];
    if (okButton != nil)
        [alert addAction:okButton];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view presentViewController:alert animated:YES completion:nil];
    });
}


+ (void)notificationAlertinView:(UIViewController *)view
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"Modal.EnableNotifications.Title", nil)
                                 message:NSLocalizedString(@"Modal.EnableNotifications.Paragraph", nil)
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
        [CountlyUtility recordEvent:@"NotificationModal_Accepted"];
        [Countly.sharedInstance giveConsentForFeature:CLYConsentPushNotifications];
        [Countly.sharedInstance
         askForNotificationPermissionWithOptions:0
         completionHandler:^(BOOL granted, NSError * error) {
            if (granted)
                [SettingsUtility registeredForNotifications];
        }];
    }];

    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Modal.Cancel", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
        [CountlyUtility recordEvent:@"NotificationModal_Declined"];
    }];
    [alert addAction:cancelButton];
    [alert addAction:okButton];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view presentViewController:alert animated:YES completion:nil];
    });
}
@end
