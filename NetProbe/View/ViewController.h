// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.


#import <UIKit/UIKit.h>
#import "LogViewController.h"
#import "TestInfoViewController.h"
#import "TestStorage.h"
#import "ResultViewController.h"

@interface ViewController : UIViewController

@property NSMutableArray *availableNetworkMeasurements;

@property (strong, nonatomic) IBOutlet UILabel *testing_historyLabel;
@property (strong, nonatomic) IBOutlet UILabel *pending_testsLabel;
@property (strong, nonatomic) IBOutlet UILabel *run_testLabel;

@property (strong, nonatomic) IBOutlet UILabel *dns_injectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *tcp_connectLabel;
@property (strong, nonatomic) IBOutlet UILabel *http_invalid_request_lineLabel;

@property (strong, nonatomic) IBOutlet UIButton *dns_injectionButton;
@property (strong, nonatomic) IBOutlet UIButton *tcp_connectButton;
@property (strong, nonatomic) IBOutlet UIButton *http_invalid_request_lineButton;

@property (strong, nonatomic) IBOutlet UIButton *runButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NetworkMeasurement *selectedMeasurement;

@property (strong, nonatomic) NSMutableArray *runningNetworkMeasurements;

@end