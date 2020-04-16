#import <Foundation/Foundation.h>

@interface NavigationBarUtility : NSObject
+ (void)setDefaults;
+ (void)setNavigationBar:(UINavigationBar *)navigationBar;
+ (void)setNavigationBar:(UINavigationBar *)navigationBar color:(UIColor*)defaultColor;
+ (void)setNavigationBar:(UINavigationBar *)navigationBar color:(UIColor*)defaultColor andTitle:(NSString*)title;
+ (void)setBarTintColor:(UINavigationBar *)navigationBar color:(UIColor*)color;
@end
