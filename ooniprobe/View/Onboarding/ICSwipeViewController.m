#import "ICSwipeViewController.h"

@interface ICSwipeViewController ()

@end

@implementation ICSwipeViewController 

- (UIViewController *)first {
    if (!_first) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil];
        _first = [sb instantiateViewControllerWithIdentifier:@"Onboarding_1"];
    }
    return _first;
}

- (UIViewController *)second {
    if (!_second) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil];
        _second = [sb instantiateViewControllerWithIdentifier:@"Onboarding_2"];
    }
    return _second;
}
- (UIViewController *)third {
    if (!_third) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil];
        _third = [sb instantiateViewControllerWithIdentifier:@"Onboarding_3"];
    }
    return _third;
}
- (UIViewController *)fourth {
    if (!_fourth) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil];
        _fourth = [sb instantiateViewControllerWithIdentifier:@"Onboarding_4"];
    }
    return _fourth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_base alpha:1.0f]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextPage) name:@"nextPage" object:nil];

    //self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.pageViewController.dataSource = self;
    viewControllers = [[NSArray alloc] initWithObjects:self.first, self.second, self.third, self.fourth, nil];

    [self.pageViewController setViewControllers:@[self.first]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)nextPage{
    index = 3;
    [self.pageViewController setViewControllers:@[self.fourth] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    if (index == 2 && _third.question_number < 3){
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
