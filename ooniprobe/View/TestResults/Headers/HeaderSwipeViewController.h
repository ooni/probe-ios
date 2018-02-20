#import <UIKit/UIKit.h>
#import "Header1ViewController.h"
#import "Header2ViewController.h"
#import "SettingsUtility.h"
#import "Result.h"

@interface HeaderSwipeViewController : UIViewController <UIPageViewControllerDataSource, UIGestureRecognizerDelegate> {
    NSArray *viewControllers;
    NSUInteger index;
}

@property (nonatomic,strong) UIPageViewController *pageViewController;

@property (nonatomic, retain) Header1ViewController *first;
@property (nonatomic, retain) Header2ViewController *second;
@property (nonatomic, strong) Result *result;

@end
