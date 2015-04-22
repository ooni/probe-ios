//
//  NetworkManager.h
//  Libight_iOS
//
//  Created by Lorenzo Primiterra on 18/03/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

@property bool running;
@property NSMutableArray *runningNetworkMeasurements;
@property NSMutableArray *completedNetworkMeasurements;

@end
