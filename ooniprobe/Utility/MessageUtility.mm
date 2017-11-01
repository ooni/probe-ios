#import "MessageUtility.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@implementation MessageUtility

+ (void)showToast:(NSString*)msg inView:(UIView*)view
{
    [view makeToast:NSLocalizedString(msg, nil)];
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
    [view presentViewController:alert animated:YES completion:nil];
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
    [view presentViewController:alert animated:YES completion:nil];
}

@end
