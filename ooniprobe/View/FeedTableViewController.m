#import "FeedTableViewController.h"

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController
@synthesize entries;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"feed", nil);
    self.client = [[CDAClient alloc] initWithSpaceKey:@"brg7eld9zwg1"
        accessToken:@"d2372f3d4caa2a58ec165bcf8e0c8fec1ae2aa49ab54e8fb14ae910ed8be90c5"];
    //[self.client registerClass:[Article class] forContentTypeWithIdentifier:@"6yvmL10FkAIkOaqgiuI4Oy"];
    Class articleClass = NSClassFromString(@"Article");
    if (articleClass) {
        [self.client registerClass:articleClass forContentTypeWithIdentifier:@"blogPost"];
    }
    /*
     [self.client initialSynchronizationWithSuccess:^(CDAResponse *response, CDASyncedSpace *space) {
         NSLog(@"Assets: %d", space.assets.count);
         NSLog(@"Entries: %d", space.entries.count);
     } failure:^(CDAResponse *response, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
*/
    
    [self.client fetchEntriesWithSuccess:^(CDAResponse *response, CDAArray *array) {
        NSArray *entries = array.items;
        //NSLog(@"%@", entries[0]);
        NSLog(@"Entries: %d", [entries count]);

        for (Article *c in entries){
            NSLog(@"%@", [c getTitle]);
        }
        //NSLog(@"%@", entries[1]);
    } failure:^(CDAResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
/*
    [self.client fetchSpaceWithSuccess:^(CDAResponse *response, CDASpace *space) {
        NSLog(@"space %@", space);
    }
                          failure:^(CDAResponse *response, NSError *error) {
                              NSLog(@"%@", error);
                          }];
 */
    /*
    [self.client performSynchronizationWithSuccess:^{
        NSLog(@"Synchronization finished.");
    } failure:^(CDAResponse *response, NSError *error) {
        // Replace this implementation with code to handle the error appropriately.
        NSLog(@"Error while loading content: %@, %@", error, [error userInfo]);
        abort();
    }];
     */

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
    return [entries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Article *c = [entries objectAtIndex:indexPath.row];
    cell.textLabel.text = c.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [c.authors objectAtIndex:0], c.publicationDate];
    //cell.imageView.image =
    NSLog(@"%@", c.images);
    return cell;
}

@end

