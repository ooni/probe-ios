#import "FeedTableViewController.h"

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController
@synthesize entries;

- (void)viewDidLoad {
    //https://www.contentful.com/blog/2014/05/09/ios-content-synchronization/
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Feed.Title", nil);
    self.client = [[CDAClient alloc] initWithSpaceKey:@"brg7eld9zwg1"
        accessToken:@"d2372f3d4caa2a58ec165bcf8e0c8fec1ae2aa49ab54e8fb14ae910ed8be90c5"];
    //[self.client registerClass:[Article class] forContentTypeWithIdentifier:@"6yvmL10FkAIkOaqgiuI4Oy"];
    Class articleClass = NSClassFromString(@"Article");
    if (articleClass) {
        [self.client registerClass:articleClass forContentTypeWithIdentifier:@"blogPost"];
    }
    
    CDASyncedSpace* space = [CDASyncedSpace readFromFile:@"/some/path"
                                                  client:self.client];
    [space performSynchronizationWithSuccess:^{
        // Handle success...
    } failure:^(CDAResponse *response, NSError *error) {
        // Handle errors...
    }];
    
    CDARequest* request = [self.client initialSynchronizationWithSuccess:^(CDAResponse *response, CDASyncedSpace *space) {
        
        //[space writeToFile:self.temporaryFileURL.path];
        
        //space = [CDASyncedSpace readFromFile:self.temporaryFileURL.path client:self.client];
        
        [space performSynchronizationWithSuccess:^{
            // Success block for subsequent sync.
        } failure:^(CDAResponse *response, NSError *error) {
            // Handle error.
        }];
    } failure:^(CDAResponse *response, NSError *error) {
        // Handle error.
    }];
    /*
     [self.client initialSynchronizationWithSuccess:^(CDAResponse *response, CDASyncedSpace *space) {
         NSLog(@"Assets: %d", space.assets.count);
         NSLog(@"Entries: %d", space.entries.count);
     } failure:^(CDAResponse *response, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
*/
    
    [self.client fetchEntriesWithSuccess:^(CDAResponse *response, CDAArray *array) {
        entries = array.items;
        //NSLog(@"%@", entries[0]);
        //NSLog(@"Entries: %d", [entries count]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
/*
        for (Article *c in entries){
            NSLog(@"%@", [c getTitle]);
        }
 */
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
    self.tabBarController.navigationItem.title = NSLocalizedString(@"Feed.Tab.Label", nil);
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
    //TODO format date, add all authors
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [c.authors objectAtIndex:0], c.publicationDate];
    //TODO CoreDataExample of contentful project
    if ([c.images count] > 0){
        CDAAsset *image = [c.images objectAtIndex:0];
        if ([image isImage]){
            cell.imageView.offlineCaching_cda = YES;
            cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [cell.imageView cda_setImageWithAsset:image placeholderImage:nil];
        }
    }
    NSLog(@"%@", c.images);
    return cell;
}

@end

