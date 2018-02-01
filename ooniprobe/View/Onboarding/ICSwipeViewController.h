#import <UIKit/UIKit.h>
#import "Onboarding1ViewController.h"
#import "Onboarding2ViewController.h"
#import "Onboarding3ViewController.h"
#import "Onboarding4ViewController.h"

@interface ICSwipeViewController : UIViewController <UIPageViewControllerDataSource, UIGestureRecognizerDelegate> {
    NSArray *viewControllers;
    NSUInteger index;
}


@property (nonatomic,strong) UIPageViewController *pageViewController;

@property (nonatomic, retain) Onboarding1ViewController *first;
@property (nonatomic, retain) Onboarding2ViewController *second;
@property (nonatomic, retain) Onboarding3ViewController *third;
@property (nonatomic, retain) Onboarding4ViewController *fourth;


@end
