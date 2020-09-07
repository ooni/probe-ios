#import "TabsViewController.h"
#import "MessageUtility.h"

@interface TabsViewController ()

@end

@implementation TabsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast:) name:@"showToast" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSettings) name:@"openSettings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToResults) name:@"goToResults" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:ONBOARDING_KEY]){
        [self performSegueWithIdentifier:@"showInformedConsent" sender:self];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:MANUAL_UPLOAD_POPUP]){
        UIAlertAction* enableButton = [UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"Modal.ManualUpload.Enable", nil)
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [self setModalValue:YES
                                                            key:@"upload_results_manually"
                                                      popupName:MANUAL_UPLOAD_POPUP];
                                        }];
        UIAlertAction* disableButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Modal.ManualUpload.Disable", nil)
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [self setModalValue:NO
                                                        key:@"upload_results_manually"
                                                  popupName:MANUAL_UPLOAD_POPUP];
                                    }];
        [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.ManualUpload.Title", nil) message:NSLocalizedString(@"Modal.ManualUpload.Paragraph", nil) okButton:enableButton cancelButton:disableButton inView:self];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:ANALYTICS_POPUP]){
        UIAlertAction* enableButton = [UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"Modal.SoundsGreat", nil)
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [self setModalValue:YES
                                                            key:@"send_analytics"
                                                      popupName:ANALYTICS_POPUP];
                                        }];
        UIAlertAction* disableButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Modal.NoThanks", nil)
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [self setModalValue:NO
                                                        key:@"send_analytics"
                                                  popupName:ANALYTICS_POPUP];
                                    }];
        [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.ShareAnalytics.Title", nil)
                               message:NSLocalizedString(@"Modal.ShareAnalytics.Paragraph", nil)
                              okButton:enableButton
                          cancelButton:disableButton
                                inView:self];
    }
}

-(void)setModalValue:(BOOL)value key:(NSString*)key popupName:(NSString*)popupName{
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:popupName];
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)showToast:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *message = [userInfo objectForKey:@"message"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:NSLocalizedString(message, nil)];
    });
}

- (void)openSettings{
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navController = [[self viewControllers] objectAtIndex:2];
        [navController popToRootViewControllerAnimated:NO];
        [self setSelectedIndex:2];
    });
}

-(void)goToResults{
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navController = [[self viewControllers] objectAtIndex:1];
        [navController popToRootViewControllerAnimated:NO];
        [self setSelectedIndex:1];
    });
}

@end
