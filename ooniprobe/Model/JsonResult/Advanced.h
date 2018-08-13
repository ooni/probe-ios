//
//  Advanced.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 13/08/18.
//  Copyright © 2018 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advanced : NSObject
@property (nonatomic, strong) NSString *packet_loss;
@property (nonatomic, strong) NSString *out_of_order;
@property (nonatomic, strong) NSString *avg_rtt;
@property (nonatomic, strong) NSString *max_rtt;
@property (nonatomic, strong) NSString *mss;
@property (nonatomic, strong) NSString *timeouts;
@end
