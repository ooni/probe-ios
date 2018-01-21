#import <UIKit/UIKit.h>
#import <ContentfulDeliveryAPI/ContentfulDeliveryAPI.h>
#import "Article.h"

@interface FeedTableViewController : UITableViewController

@property (nonatomic, strong)  CDAClient *client;
@end
