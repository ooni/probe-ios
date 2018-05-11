#import "TabsViewController.h"

@interface TabsViewController ()

@end

@implementation TabsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast:) name:@"showToast" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSettings) name:@"openSettings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToResults) name:@"goToResults" object:nil];

    UITabBarItem * tabItem = [self.tabBar.items objectAtIndex: 0];
    tabItem.image = [UIImage imageNamed:@"tab_dashboard"];
    tabItem.title = NSLocalizedString(@"Dashboard.Tab.Label", nil);

    UITabBarItem * tabItem1 = [self.tabBar.items objectAtIndex: 1];
    tabItem1.image = [UIImage imageNamed:@"tab_test_results"];
    tabItem1.title = NSLocalizedString(@"TestResults.Overview.Tab.Label", nil);
    
    UITabBarItem * tabItem2 = [self.tabBar.items objectAtIndex: 2];
    tabItem2.image = [UIImage imageNamed:@"tab_feed"];
    tabItem2.title = NSLocalizedString(@"Feed.Tab.Label", nil);
    [tabItem2 setEnabled:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first_run"]){
        [self performSegueWithIdentifier:@"showInformedConsent" sender:self];
    }
    UITabBarItem * tabItem2 = [self.tabBar.items objectAtIndex: 2];
    [tabItem2 setEnabled:NO];
}

-(void)showToast:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *message = [userInfo objectForKey:@"message"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:NSLocalizedString(message, nil)];
    });
}

- (void)openSettings{
    [self performSegueWithIdentifier:@"settings" sender:self];
}

-(void)goToResults{
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navController = [[self viewControllers] objectAtIndex:1];
        [navController popToRootViewControllerAnimated:NO];
        [self setSelectedIndex:1];
    });
}

@end
