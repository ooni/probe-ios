#import <UIKit/UIKit.h>
#import <ContentfulDeliveryAPI/ContentfulDeliveryAPI.h>
#import "Article.h"
#import "CDAPersistenceManager.h"

@interface FeedTableViewController : UITableViewController

@property (nonatomic, strong)  CDAClient *client;
@property (nonatomic, strong)  NSArray *entries;

@end
