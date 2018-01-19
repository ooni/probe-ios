#import <UIKit/UIKit.h>
#import <ContentfulDeliveryAPI/ContentfulDeliveryAPI.h>

@interface FeedTableViewController : UITableViewController

@property (nonatomic, strong)  CDAClient *client;
@end
