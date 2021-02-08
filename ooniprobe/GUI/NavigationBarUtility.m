#import "NavigationBarUtility.h"

@implementation NavigationBarUtility

+ (void)setDefaults{
    if (@available(iOS 13, *)){
        UINavigationBarAppearance *appearance = [self getDefaultAppearance];
        [UINavigationBar appearance].scrollEdgeAppearance = appearance;
        [UINavigationBar appearance].compactAppearance = appearance;
        [UINavigationBar appearance].standardAppearance = appearance;
    }
    else {
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"FiraSans-SemiBold" size:16], NSFontAttributeName, nil]];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorNamed:@"color_blue5"]];
        [[UINavigationBar appearance] setTranslucent:FALSE];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
}

+ (UINavigationBarAppearance*)getDefaultAppearance API_AVAILABLE(ios(13.0)){
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    [appearance configureWithOpaqueBackground];
    appearance.largeTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"FiraSans-SemiBold" size:16], NSFontAttributeName, nil];
    appearance.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"FiraSans-SemiBold" size:16], NSFontAttributeName, nil];
    appearance.backgroundColor = [UIColor colorNamed:@"color_base"];
    return appearance;
}


+ (void)setNavigationBar:(UINavigationBar *)navigationBar{
    [self setNavigationBar:navigationBar color:[UIColor colorNamed:@"color_base"]];
}

+ (void)setNavigationBar:(UINavigationBar *)navigationBar color:(UIColor*)defaultColor{
    if (@available(iOS 13, *)){
        UINavigationBarAppearance *navBar = [UINavigationBar appearance].standardAppearance;
        navBar.backgroundColor = defaultColor;
        navBar.shadowImage = [UIImage new];
        navBar.backgroundImage = [UIImage new];
        navBar.shadowColor = [UIColor clearColor];
        navigationBar.standardAppearance = navBar;
        navigationBar.scrollEdgeAppearance = navBar;
        navigationBar.compactAppearance = navBar;
    }
    else {
        [navigationBar setBarTintColor:defaultColor];
        [navigationBar setShadowImage:[UIImage new]];
        [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

+ (void)setBarTintColor:(UINavigationBar *)navigationBar color:(UIColor*)color{
    if (@available(iOS 13, *)){
        UINavigationBarAppearance *navBar = [UINavigationBar appearance].standardAppearance;
        navBar.backgroundColor = color;
        navigationBar.standardAppearance = navBar;
        navigationBar.scrollEdgeAppearance = navBar;
        navigationBar.compactAppearance = navBar;
    }
    else {
        [navigationBar setBarTintColor:color];
    }
}

@end
