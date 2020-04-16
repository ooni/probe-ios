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
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRGBHexString:color_white alpha:1.0f], NSForegroundColorAttributeName, [UIFont fontWithName:@"FiraSans-SemiBold" size:16], NSFontAttributeName, nil]];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];
        [[UINavigationBar appearance] setTranslucent:FALSE];
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    }
}

+ (UINavigationBarAppearance*)getDefaultAppearance API_AVAILABLE(ios(13.0)){
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    [appearance configureWithOpaqueBackground];
    appearance.largeTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRGBHexString:color_white alpha:1.0f], NSForegroundColorAttributeName, [UIFont fontWithName:@"FiraSans-SemiBold" size:16], NSFontAttributeName, nil];
    appearance.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRGBHexString:color_white alpha:1.0f], NSForegroundColorAttributeName, [UIFont fontWithName:@"FiraSans-SemiBold" size:16], NSFontAttributeName, nil];
    appearance.backgroundColor = [UIColor colorWithRGBHexString:color_base alpha:1.0f];
    return appearance;
}


+ (void)setNavigationBar:(UINavigationBar *)navigationBar{
    [self setNavigationBar:navigationBar color:[UIColor colorWithRGBHexString:color_base alpha:1.0f]];
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
