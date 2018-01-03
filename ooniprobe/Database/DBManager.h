//
//  DBManager.h
//  SQLite3DBSample
//
//  Created by Bilal ARSLAN on 05/07/14.
//  Copyright (c) 2014 Bilal ARSLAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(instancetype) initWithDatabaseFileName:(NSString *)dbFileNane;
-(NSArray *)loadDataFromDBWithQuery:(NSString *)query;   //  select query.
-(void)executeQuery:(NSString *)query;          //  insert, update, delete queries.
@end
