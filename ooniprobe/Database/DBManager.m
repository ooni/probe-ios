//
//  DBManager.m
//  SQLite3DBSample
//
//  Created by Bilal ARSLAN on 05/07/14.
//  Copyright (c) 2014 Bilal ARSLAN. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFileName;
@property (nonatomic, strong) NSMutableArray *arrQueryResults;

-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end


@implementation DBManager

#pragma mark - Custom Init
-(instancetype) initWithDatabaseFileName:(NSString *)dbFileName
{
    self = [super init];
    
    if (self)
    {
        //  Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        //  Keep the database filename.
        self.databaseFileName = dbFileName;
        
        //  Copy the databse file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

#pragma mark - Private Methods
-(void)copyDatabaseIntoDocumentsDirectory
{
    //  Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath])
    {
        //  The database file does not exist in the documents directory, so copy it form the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFileName];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        //  Check if any error occured during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable
{
    //  Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    
    //  Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFileName];
    
    
    //  Deleting all previous data from arrays.
    
    //  Initialize the results array.
    if (self.arrQueryResults != nil)
    {
        [self.arrQueryResults removeAllObjects];
        self.arrQueryResults = nil;
    }
    self.arrQueryResults = [[NSMutableArray alloc] init];
    
    
    //  Initialize the column names array.
    if (self.arrColumnNames != nil)
    {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    //  Open the database with result.
    int openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    
    //  Open the database
    if (openDatabaseResult == SQLITE_OK)
    {
        //  Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;

        //  Load all data from database to memory or load the affedtedRows.
        int prepareStatementResult = sqlite3_prepare(sqlite3Database, query , -1, &compiledStatement, NULL);
        
        if (prepareStatementResult == SQLITE_OK)
        {
            //  Check if the query is non-executable (select).
            if (!queryExecutable)
            {
                //  In this case data must be loaded from the database.
                
                //  Declare an array to keep the data for each fetch row.
                NSMutableArray *arrEachDataRow;
                
                //  Loop through the result and add them to the results array row by row.
                while (sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    //  Initialize the mutable array that will contain the data of a fetched each row.
                    arrEachDataRow = [[NSMutableArray alloc] init];
                    
                    //  Get the load total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    //  Go through all columns and fetch each columns data.
                    for (int i = 0; i<totalColumns; i++)
                    {
                        //  Convert the column data to text(characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        //  If there are contents in the current column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL)
                        {
                            [arrEachDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        //  Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns)
                        {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    //  Store each fecthed data row in the results array, but first check if there is actually data in arrEachDataRow.
                    if (arrEachDataRow.count > 0)
                    {
                        [self.arrQueryResults addObject:arrEachDataRow];
                    }
                }
            }
            //  Otherwise it's executable query.
            else
            {
                //  This is the case of an executable query(insert, update, delete, ...)
                
                //  Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE)
                {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    //  Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else
                {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Execute Query Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else
        {
            //  In the database cannot be opened then show the error message on the debugger.
            NSLog(@"DB Open Error: %s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}

#pragma mark - Public Methods
//  Public Method -> select query.
-(NSArray *)loadDataFromDBWithQuery:(NSString *)query
{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrQueryResults;
}

//  Public Method -> insert, update, delete queries.
-(void)executeQuery:(NSString *)query
{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
