#import <UIKit/UIKit.h>

@interface ICSwipeViewController : UIViewController <UIPageViewControllerDataSource, UIGestureRecognizerDelegate> {
    NSArray *viewControllers;
    int question_number;
}


@property (nonatomic,strong) UIPageViewController *PageViewController;

@property (nonatomic, retain) UIViewController *first;
@property (nonatomic, retain) UIViewController *second;
@property (nonatomic, retain) UIViewController *third;
@property (nonatomic, retain) UIViewController *fourth;


@end
