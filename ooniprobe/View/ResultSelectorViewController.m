// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "ResultSelectorViewController.h"

@interface ResultSelectorViewController ()

@end

@implementation ResultSelectorViewController;
@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *content = [items objectAtIndex:indexPath.row];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"input %@", [json objectForKey:@"input"]];
    if ([[json objectForKey:@"test_keys"] objectForKey:@"blocking"] != [NSNull null]){
        if (![[[json objectForKey:@"test_keys"] objectForKey:@"blocking"] boolValue]){
            cell.imageView.image = [UIImage imageNamed:@"censorship_no"];
        }
        else cell.imageView.image = [UIImage imageNamed:@"censorship_yes"];
    }
    else cell.imageView.image = [UIImage imageNamed:@"censorship_yes"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toResult" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toResult"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ResultViewController *vc = (ResultViewController * )segue.destinationViewController;
        [vc setContent:[items objectAtIndex:indexPath.row]];
    }
}

@end
