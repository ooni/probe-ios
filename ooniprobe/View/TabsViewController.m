#import "TabsViewController.h"

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
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first_run"]){
        [self performSegueWithIdentifier:@"showInformedConsent" sender:self];
    }
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
