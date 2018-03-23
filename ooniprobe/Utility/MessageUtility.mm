#import "MessageUtility.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "NotificationService.h"

@implementation MessageUtility

+ (void)showToast:(NSString*)msg inView:(UIView*)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [view makeToast:NSLocalizedString(msg, nil)];
    });
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg inView:(UIViewController *)view
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"ok", nil)
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
                                   actionWithTitle:NSLocalizedString(@"cancel", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
    [alert addAction:cancelButton];
    [alert addAction:okButton];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view presentViewController:alert animated:YES completion:nil];
    });
}

+ (void)notificationAlertinView:(UIViewController *)view
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:NSLocalizedString(@"enable_notification_first_time", nil)
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"ok", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [NotificationService registerUserNotification];
                                   //TODO callback and enable the key the user was trying to enable.
                                   //TODECIDE when popup randomly what to enable
                               }];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"cancel", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
    [alert addAction:cancelButton];
    [alert addAction:okButton];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view presentViewController:alert animated:YES completion:nil];
    });
}

@end
