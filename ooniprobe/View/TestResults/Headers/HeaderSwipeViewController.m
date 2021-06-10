#import "HeaderSwipeViewController.h"

@interface HeaderSwipeViewController ()

@end

@implementation HeaderSwipeViewController
@synthesize result;

- (UIViewController *)first {
    if (!_first) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Result" bundle:nil];
        if ([result.test_group_name isEqualToString:@"middle_boxes"])
            _first = [sb instantiateViewControllerWithIdentifier:@"test_summary_header_mb"];
        else if ([result.test_group_name isEqualToString:@"experimental"])
            return nil;
        else
            _first = [sb instantiateViewControllerWithIdentifier:@"test_summary_header_1"];
        [_first setResult:result];
    }
    return _first;
}

- (UIViewController *)second {
    if (!_second) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Result" bundle:nil];
        _second = [sb instantiateViewControllerWithIdentifier:@"test_summary_header_2"];
        [_second setResult:result];
    }
    return _second;
}

- (UIViewController *)third {
    if (!_third) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Result" bundle:nil];
        _third = [sb instantiateViewControllerWithIdentifier:@"test_summary_header_3"];
        [_third setResult:result];
    }
    return _third;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[TestUtility getBackgroundColorForTest:result.test_group_name]];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    if (self.first != nil) {
        viewControllers = [[NSArray alloc] initWithObjects:self.first, self.second, self.third, nil];
        [self.pageViewController setViewControllers:@[self.first]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }
    else {
        viewControllers = [[NSArray alloc] initWithObjects:self.second, self.third, nil];
        [self.pageViewController setViewControllers:@[self.second]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    //Went back
    index = [viewControllers indexOfObject:viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    //Went forward
    index = [viewControllers indexOfObject:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [viewControllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - Other Methods
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([viewControllers count] == 0) || (index >= [viewControllers count])) {
        return nil;
    }
    return [viewControllers objectAtIndex:index];
}


#pragma mark - No of Pages Methods
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [viewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return index;
}

@end

