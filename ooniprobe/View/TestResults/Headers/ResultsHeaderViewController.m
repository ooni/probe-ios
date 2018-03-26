#import "ResultsHeaderViewController.h"

@interface ResultsHeaderViewController ()

@end

@implementation ResultsHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLine:self.view2];
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        [self addLine:self.view1];
    }
    else {
        [self addLine:self.view3];
    }
    [self.testsLabel setText:NSLocalizedString(@"tests", nil)];
    [self.networksLabel setText:NSLocalizedString(@"networks", nil)];
    [self.dataUsageLabel setText:NSLocalizedString(@"data_usage", nil)];
    filter = @"";
    [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadQueryNoFilter) name:@"networkTestEnded" object:nil];
    self.dropdownMenu.tintColor = [UIColor colorWithRGBHexString:color_black alpha:1.0f];
    /*
    self.disclosureIndicatorView.image = image;
    [self.disclosureIndicatorView sizeToFit];
    CGFloat insetLeft = 8;
    CGFloat insetRight = (image.size.width > 0) ? image.size.width + 4 + insetLeft : insetLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, insetLeft, 0, insetRight);
    [self setNeedsLayout];
*/
   //[self.dropdownMenu.disclosureIndicatorImage setFrame:CGRectMake(0, 0, 35, 50)];
    //[self.dropdownMenu.disclosureIndicatorImage setNeedsLayout];

/*
    let query = Person.query()
    .limit(1000)
    .orderBy("Name")
    .offset(25)
    .batchSize(30)
    
    let numberOfPeople = query.count()
    let peopleBySurname = query.groupBy("surname")
    let totalAge = query.sumOf("age")
    
    //SRKRawResults* results = [SharkORM rawQuery:@""];
    
    +(SRKRawResults*)rawQuery:(NSString*)sql;
    

    SRKResultSet* results = [[Result query] count]

    SRKResultSet* results = [[[Result query] sumOf:@"datausageUp"] ]


    SELECT SUM(datausageUp), SUM(datausageDown)
    FROM tabella
    WHERE date < "2017-01-01"

    ```SELECT
    COUNT(DISTINCT asn)
    FROM tabella
    ```
 */
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadQuery];
}

-(void)reloadQueryNoFilter{
    filter = @"";
    [self reloadQuery];
}

-(void)reloadQuery{
    SRKQuery *query;
    if ([filter length] > 0)
        query = [[[Result query] where:[NSString stringWithFormat:@"name = '%@'", filter]] orderByDescending:@"startTime"];
    else
        query = [[Result query] orderByDescending:@"startTime"];
    
    double dataUsageDown = [query sumOf:@"dataUsageDown"];
    double dataUsageUp = [query sumOf:@"dataUsageUp"];
    
    [self.upLabel setText:[NSByteCountFormatter stringFromByteCount:dataUsageUp countStyle:NSByteCountFormatterCountStyleFile]];
    [self.downLabel setText:[NSByteCountFormatter stringFromByteCount:dataUsageDown countStyle:NSByteCountFormatterCountStyleFile]];
    [self.numberTestsLabel setText:[NSString stringWithFormat:@"%llu", [query count]]];
    //TODO BUG this count also the nulls
    [self.numberNetworksLabel setText:[NSString stringWithFormat:@"%lu", [[query distinct:@"asn"] count]]];
    [self.delegate testFilter:query];
}

#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return [[SettingsUtility getTestTypes] count]+1;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component{
    NSString *text = NSLocalizedString(@"filter_tests", nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"FiraSans-Regular" size:16],
                                 NSForegroundColorAttributeName:[UIColor colorWithRGBHexString:color_black alpha:1.0f]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(NSAttributedString*)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *text;
    NSDictionary *attributes;
    if ((row == 0 && [filter isEqualToString:@""]) || (row > 0 && [[[SettingsUtility getTestTypes] objectAtIndex:row-1] isEqualToString:filter]))
        attributes = @{NSFontAttributeName: [UIFont fontWithName:@"FiraSans-SemiBold" size:16],
                       NSForegroundColorAttributeName:[UIColor colorWithRGBHexString:color_black alpha:1.0f]};
    else
        attributes = @{NSFontAttributeName: [UIFont fontWithName:@"FiraSans-Regular" size:16],
                       NSForegroundColorAttributeName:[UIColor colorWithRGBHexString:color_black alpha:1.0f]};

    if (row == 0)
        text = NSLocalizedString(@"all_tests", nil);
    else {
        NSArray *tests =  [SettingsUtility getTestTypes];
        text = NSLocalizedString([tests objectAtIndex:row-1], nil);
    }
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/*
- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0)
        return NSLocalizedString(@"all_tests", nil);
    NSArray *tests =  [SettingsUtility getTestTypes];
    return NSLocalizedString([tests objectAtIndex:row-1], nil);
}
*/

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ((row == 0 && [filter isEqualToString:@""]) || (row > 0 && [[[SettingsUtility getTestTypes] objectAtIndex:row-1] isEqualToString:filter]))
        return [UIColor colorWithRGBHexString:color_gray2 alpha:1.0f];
    else
        return [UIColor whiteColor];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *current = @"";
    if (row > 0){
        NSArray *tests =  [SettingsUtility getTestTypes];
        current = [tests objectAtIndex:row-1];
    }
    filter = current;
    [self reloadQuery];

    double delayInSeconds = 0.15;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.dropdownMenu closeAllComponentsAnimated:YES];
    });
}

-(void)addLine:(UIView*)view{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, view.frame.size.height)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:lineView];
}

@end
