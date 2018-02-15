#import "ResultsHeaderViewController.h"

@interface ResultsHeaderViewController ()

@end

@implementation ResultsHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLine:self.view2];
    [self addLine:self.view3];
    [self.testsLabel setText:NSLocalizedString(@"tests", nil)];
    [self.networksLabel setText:NSLocalizedString(@"networks", nil)];
    [self.dataUsageLabel setText:NSLocalizedString(@"data_usage", nil)];
    [self.filterButton setTitle:NSLocalizedString(@"filter_tests", nil) forState:UIControlStateNormal];
    filter = @"";
    SRKQuery *query =[[Result query] orderBy:@"startTime"];

/*
    let query = Person.query()
    .limit(1000)
    .orderBy("Name")
    .offset(25)
    .batchSize(30)
    
    let numberOfPeople = query.count()
    let peopleBySurname = query.groupBy("surname")
    let totalAge = query.sumOf("age")
    
    //TODO reload in case of filter
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
    //numberTestsLabel,numberNetworksLabel, upLabel,downLabel
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //TODO query every appear or send update every test?
    [self reloadQuery];
}

-(void)reloadQuery{
    SRKQuery *query;
    if ([filter length] > 0)
        query = [[Result query] where:[NSString stringWithFormat:@"name = '%@'", filter]];
    else
        query = [Result query];
    
    double dataUsageDown = [query sumOf:@"dataUsageDown"];
    double dataUsageUp = [query sumOf:@"dataUsageUp"];
    [self.upLabel setText:[NSString stringWithFormat:@"%.0f", dataUsageUp]];
    [self.downLabel setText:[NSString stringWithFormat:@"%.0f", dataUsageDown]];
    [self.numberTestsLabel setText:[NSString stringWithFormat:@"%llu", [query count]]];
    [self.numberNetworksLabel setText:[NSString stringWithFormat:@"%lu", [[query distinct:@"asn"] count]]];
    [self.delegate testFilter:query];
}

-(IBAction)showFilter:(id)sender{
    //TODO use https://github.com/PhamBaTho/BTNavigationDropdownMenu
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* all_tests = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"all_tests", nil)
                               style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    filter = @"";
                                    [self.filterButton setTitle:NSLocalizedString(@"all_tests", nil) forState:UIControlStateNormal];
                                    [self reloadQuery];

                                }];
    [alert addAction:all_tests];

    NSArray *tests =  [SettingsUtility getTestTypes];
    for (NSString *current in tests){
        UIAlertAction* button = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(current, nil)
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       filter = current;
                                       [self.filterButton setTitle:NSLocalizedString(current, nil) forState:UIControlStateNormal];
                                       [self reloadQuery];
                                   }];
        [alert addAction:button];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addLine:(UIView*)view{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, view.frame.size.height)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:lineView];
}

@end
