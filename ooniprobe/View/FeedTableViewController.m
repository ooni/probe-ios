#import "FeedTableViewController.h"
#import <ContentfulDeliveryAPI/ContentfulDeliveryAPI.h>

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"feed", nil);
    CDAClient *client = [[CDAClient alloc] initWithSpaceKey:@"brg7eld9zwg1"
        accessToken:@"d2372f3d4caa2a58ec165bcf8e0c8fec1ae2aa49ab54e8fb14ae910ed8be90c5"];
    [client fetchEntriesMatching:@{ @"content_type": @"cat" }
                         success:^(CDAResponse *response, CDAArray *entries) {
                             NSLog(@"%@", [[entries.items firstObject] fields]);
                         }
                         failure:^(CDAResponse *response, NSError *error) {
                             NSLog(@"%@", error);
                         }];
    /*
    [client fetchEntriesWithSuccess:^(CDAResponse *response, CDAArray *array) {
        NSArray *entries = array.items;
        NSLog(@"%@", entries);
    } failure:^(CDAResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    [client fetchSpaceWithSuccess:^(CDAResponse *response, CDASpace *space) {
        NSLog(@"space %@", space);
    }
                          failure:^(CDAResponse *response, NSError *error) {
                              NSLog(@"%@", error);
                          }];
*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = NSLocalizedString(@"feed", nil);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", indexPath.row];
    return cell;
}

@end

