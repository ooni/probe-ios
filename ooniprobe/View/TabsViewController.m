#import "TabsViewController.h"
#import "MessageUtility.h"
#import "Measurement.h"
#import "SettingsUtility.h"

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
    //we don't want to flood the user with popups
    else if ([SettingsUtility getAppOpenCount] % NOTIFICATION_POPUP_COUNT == 0
             && ![SettingsUtility isNotificationEnabled]
             && ![[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATION_POPUP_DISABLE]){
        [MessageUtility notificationAlertinView:self];
        [SettingsUtility incrementAppOpenCount];
    }
}

-(void)setModalValue:(BOOL)value key:(NSString*)key popupName:(NSString*)popupName{
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:popupName];
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
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
