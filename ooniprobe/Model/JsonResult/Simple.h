//
//  Simple.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 13/08/18.
//  Copyright © 2018 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Simple : NSObject
@property (nonatomic, strong) NSNumber *upload;
@property (nonatomic, strong) NSNumber *download;
@property (nonatomic, strong) NSNumber *ping;
@property (nonatomic, strong) NSNumber *median_bitrate;
@property (nonatomic, strong) NSNumber *min_playout_delay;
@end
