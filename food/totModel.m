//
//  totModel.m
//  see test_Model.m for usage examples
//
//  Created by Hao on 4/21/12.

#import "totModel.h"
#import "totEventName.h"
#import "totUtility.h"

@implementation totModel

@synthesize dbfile;

- (id) init {
    self = [super init];
    if (self != nil) {
        @try {
            NSFileManager* fileMgr = [NSFileManager defaultManager];
            
            // db file name 
            dbfile = @"totdb.sqlite";
            
            // locate db file and open db
            NSLog(@"[db] init");
            db = nil;
            // get filename for db
            NSString *dbPath = [[totModel GetDocumentDirectory] stringByAppendingPathComponent:dbfile];
            // does it exist?
            BOOL success = [fileMgr fileExistsAtPath:dbPath];
            if(!success) {
                // copy it if not exist
                [self CopyDbToDocumentsFolder];
            }
            success = [fileMgr fileExistsAtPath:dbPath];
            if(!success) {
                NSLog(@"[db] Cannot locate database file '%@'.", dbPath);
                return false;
            }
            if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"[db] An error has occured open db.");
                db = nil;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"[db] An exception occured: %@", [exception reason]);
        }
    }
    return self;
}

- (void) dealloc {
    // release my objects
    if (db != nil) {
        sqlite3_close(db);
        db = nil;
    }
}

-(void)CopyDbToDocumentsFolder{
    NSError *err=nil;
    
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbfile];
    
    NSString *copydbpath = [[totModel GetDocumentDirectory] stringByAppendingPathComponent:dbfile];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:copydbpath error:&err];
    
    //NSLog(@"DB path = %@", copydbpath);
    
    if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err]) {
        NSLog(@"Unable to copy database.");
    }
}
    
+(NSString *)GetDocumentDirectory{
//    fileMgr = [NSFileManager defaultManager];
//    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // a better one
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *homeDir = [paths objectAtIndex:0]; // Get documents folder

    return homeDir;
}

- (int) addEvent:(int)baby_id event:(NSString*)event datetime:(NSDate*)datetime value:(NSString*)value {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formattedDateString = [dateFormatter stringFromDate:datetime];
    //NSLog(@"second time %@", formattedDateString);
    return [self addEvent:baby_id event:event datetimeString:formattedDateString value:value];
}

// return -1 if failed, otherwise return a positive number for event_id
- (int) addEvent:(int)baby_id event:(NSString*)event datetimeString:(NSString*)datetime value:(NSString*)value {
    if (db == nil) {
        NSLog(@"Can't open db");
        return false;
    }

    int re = NO_EVENT;
    sqlite3_stmt *stmt = nil;
    @try {
        const char *sql = "Insert into event (baby_id, time, name, value) VALUES (?,?,?,?)";

        int ret;
        ret = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
        if( ret == SQLITE_OK ) {
            sqlite3_bind_int (stmt, 1, baby_id); // baby_id
            sqlite3_bind_text(stmt, 2, [datetime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt, 3, [event UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt, 4, [value UTF8String], -1, SQLITE_TRANSIENT);
            ret = sqlite3_step(stmt);
            if( ret != SQLITE_DONE ) {
                NSLog(@"[db] addEvent step return %d", ret);
            }
            else {
                // get the event id
                int event_id = (int)sqlite3_last_insert_rowid(db);
                if( re != 0 ) re = event_id; // if last id is 0 it is failure
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return re;
    }
}

// add a system-wide preference, such as accounts
- (BOOL) addPreferenceNoBaby:(NSString*)pref_name value:(NSString*)value {
    return [self addPreference:PREFERENCE_NO_BABY preference:pref_name value:value];
}

// add a preference specific to a baby or an account
- (BOOL) addPreference:(int)baby_id preference:(NSString*)pref_name value:(NSString*)value {
    return [self addEvent:baby_id event:pref_name datetime:[NSDate date] value:value];
}

// pref_name is something like "Account/billhao@gmail.com"
- (NSString*) getPreferenceNoBaby:(NSString*)pref_name {
    return [self getPreference:PREFERENCE_NO_BABY preference:pref_name];
}

- (int) getPreferenceNoBabyCount:(NSString*)pref_name {
    return [self getEventCount:PREFERENCE_NO_BABY event:pref_name];
}

- (NSString*) getPreference:(int)baby_id preference:(NSString*)pref_name {
    NSMutableArray* array = [self getItem:baby_id name:pref_name limit:-1 offset:-1 startDate:nil endDate:nil];
    if( array.count > 0 ) {
        totEvent* e = [array objectAtIndex:0];
        return e.value;
    }
    else
        return nil;
}

// add a system-wide preference, such as accounts
- (BOOL) updatePreferenceNoBaby:(NSString*)pref_name value:(NSString*)value {
    return [self updatePreference:PREFERENCE_NO_BABY preference:pref_name value:value];
}

// add a preference specific to a baby or an account
- (BOOL) updatePreference:(int)baby_id preference:(NSString*)pref_name value:(NSString*)value {
    // remove key if it exists
    int cnt = [self getEventCount:baby_id event:pref_name];
    if( cnt < 0 )
        return FALSE;
    else if( cnt > 0 ) {
        // remove keys
        BOOL re = [self deleteEvents:baby_id event:pref_name];
        if( !re ) return FALSE;
    }
    
    // add preference
    return [self addPreference:baby_id preference:pref_name value:value];
}

// delete a preference
- (void) deletePreferenceNoBaby:(NSString*)pref_name {
    [self deleteEvents:PREFERENCE_NO_BABY event:pref_name];
}

// get N events in a category (event) before current_event_id (N=limit)
- (NSMutableArray *) getPreviousEvent:(int)baby_id event:(NSString*)event limit:(int)limit current_event_date:(NSDate*)current_event_date {
    return [self getEvent:baby_id event:event limit:limit offset:0 startDate:nil endDate:current_event_date];
    //return [self getEvent:baby_id event:event limit:limit offset:1];
}

// get events with name
- (NSMutableArray *) getEvent :(int)baby_id event:(NSString*)event {
    return [self getEvent:baby_id event:event limit:0 offset:0 startDate:nil endDate:nil]; // call the same function with no limit
}

// get limited # of events with name
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit {
    return [self getEvent:baby_id event:event limit:limit offset:0 startDate:nil endDate:nil];
}

// get limited # of events at offset with name
- (NSMutableArray *) getEvent:(int)baby_id limit:(int)limit offset:(int)offset {
    return [self getEvent:baby_id event:nil limit:limit offset:offset startDate:nil endDate:nil];
}

// get limited # of events at offset with name
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit offset:(int)offset {
    return [self getEvent:baby_id event:event limit:limit offset:offset startDate:nil endDate:nil];
}

// get all events in a time period
- (NSMutableArray *) getEvent:(int)baby_id startDate:(NSDate*)start endDate:(NSDate*)end {
    return [self getEvent:baby_id event:nil limit:0 offset:0 startDate:start endDate:end]; // call with a nil event
}

// get all events in a time period and contain the string in name
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event startDate:(NSDate*)start endDate:(NSDate*)end {
    return [self getEvent:baby_id event:event limit:0 offset:0 startDate:start endDate:end];
}

- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit offset:(int)offset startDate:(NSDate*)start endDate:(NSDate*)end {
    return [self getEvent:baby_id event:event limit:limit offset:offset startDate:start endDate:end orderByDesc:TRUE];
}

- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit offset:(int)offset startDate:(NSDate*)start endDate:(NSDate*)end orderByDesc:(BOOL)orderByDesc {
    return [self getEvent:baby_id event:event limit:limit offset:offset startDate:start endDate:end orderByDesc:orderByDesc min_event_id:-1 max_event_id:-1];
}

// TODO assume no two events have same datetime. otherwise some events may be missed when end date is specified
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit offset:(int)offset startDate:(NSDate*)start endDate:(NSDate*)end orderByDesc:(BOOL)orderByDesc min_event_id:(int)min_event_id max_event_id:(int)max_event_id {

    NSMutableArray *events = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return events;
        }
        
        NSString* searchname = nil;
        if( event!=nil ) searchname = [NSString stringWithFormat:@"%@%%", event];
        //NSLog(@"%@", searchname);
        NSString* sql_main = @"SELECT event.event_id, event.time, event.name, event.value FROM event %@ ORDER BY datetime(event.time) %@, event.event_id %@ %@";
        NSString* sql_condition;
        if( event!=nil ) {
            if( start!=nil && end!=nil ) {
                sql_condition = @"WHERE name LIKE ? AND datetime(time) >= ? AND datetime(time) < ?";
            }
            else if( start!=nil ) {
                sql_condition = @"WHERE name LIKE ? AND datetime(time) > ?";
            }
            else if( end!=nil ) {
                sql_condition = @"WHERE name LIKE ? AND datetime(time) < ?";
            }
            else {
                sql_condition = @"WHERE name LIKE ?";
            }
        }
        else {
            if( start!=nil && end!=nil ) {
                sql_condition = @"WHERE datetime(time) >= ? AND datetime(time) < ?";
            }
            else if( start!=nil ) {
                sql_condition = @"WHERE datetime(time) >= ?";
            }
            else if( end!=nil ) {
                sql_condition = @"WHERE datetime(time) < ?";
            }
            else {
                sql_condition = @"";
            }
        }
        if( min_event_id > -1 || max_event_id > -1 ) {
            if( sql_condition.length == 0 )
                sql_condition = @"WHERE ";
            else
                sql_condition = [NSString stringWithFormat:@"%@ AND", sql_condition];
            
            if( min_event_id > -1 && max_event_id > -1 )
                sql_condition = [NSString stringWithFormat:@"%@ event.event_id > %d AND event.event_id < %d", sql_condition, min_event_id, max_event_id];
            else if( min_event_id > -1 )
                sql_condition = [NSString stringWithFormat:@"%@ event.event_id > %d", sql_condition, min_event_id];
            else if( max_event_id > -1 )
                sql_condition = [NSString stringWithFormat:@"%@ event.event_id < %d", sql_condition, max_event_id];
        }
        
        NSString* sql_order = @"";
        if( orderByDesc )
            sql_order = @"DESC";
        else
            sql_order = @"ASC";
        
        NSString* sql_limit = @"";
        if( limit > 0 ) {
            if( offset > 0 )
                sql_limit = @"LIMIT ?,?";
            else
                sql_limit = @"LIMIT ?";
        }
        
        NSString* sql = [NSString stringWithFormat:sql_main, sql_condition, sql_order, sql_order, sql_limit];
        //NSLog(@"[db] SQL=%@", sql);
        
        const char *sqlz = [sql cStringUsingEncoding:NSASCIIStringEncoding];
        if(sqlite3_prepare_v2(db, sqlz, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return events;
        }
        int param_cnt = 0;
        if( event != nil ) {
            param_cnt++;
            int ret = sqlite3_bind_text(stmt, param_cnt, [searchname UTF8String], -1, SQLITE_TRANSIENT);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        }
        if( start != nil ) {
            param_cnt++;
            int ret = sqlite3_bind_text(stmt, param_cnt, [[totEvent formatTime:start] UTF8String], -1, SQLITE_TRANSIENT);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        }
        if( end != nil ) {
            param_cnt++;
            int ret = sqlite3_bind_text(stmt, param_cnt, [[totEvent formatTime:end] UTF8String], -1, SQLITE_TRANSIENT);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        }
        if( limit > 0 ) {
            if( offset > 0 ) {
                param_cnt++;
                int ret = sqlite3_bind_int(stmt, param_cnt, offset);
                if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_int %d", ret);
            }
            param_cnt++;
            int ret = sqlite3_bind_int(stmt, param_cnt, limit);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_int %d", ret);
        }
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            int i = sqlite3_column_int(stmt, 0);
            NSString *time  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 1)];
            NSString *name  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 2)];
            NSString *value = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 3)];
            //NSLog(@"[db] record, %d, %@", i, value);
            
            totEvent *e = [[totEvent alloc] init];
            e.event_id = i;
            e.baby_id = baby_id;
            e.name = name;
            e.value = value;
            //NSLog(@"model setTimeFromText %@", time);
            [e setTimeFromText:time];
            [events addObject:e];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return events;
    }
}

// getEvent with pagination. do not use limit and offset, which has performance issues with sqlite
// see http://www.sqlite.org/cvstrac/wiki?p=ScrollingCursor
- (NSMutableArray *) getEventWithPagination:(int)baby_id limit:(int)limit startFrom:(totEvent*)lastEvent {
    NSDate* enddate;
    if( lastEvent )
        enddate = lastEvent.datetime;
    else
        enddate = [NSDate date];
    return [self getEvent:baby_id event:nil limit:limit offset:-1 startDate:nil endDate:enddate orderByDesc:TRUE];
}



// this is copied from getEvent, the difference is that this function return exact matches, not LIKE
- (NSMutableArray *) getItem:(int)baby_id name:(NSString*)name limit:(int)limit offset:(int)offset startDate:(NSDate*)start endDate:(NSDate*)end {
    NSMutableArray *events = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return events;
        }
        
        NSString* searchname = nil;
        if( name!=nil ) searchname = [NSString stringWithFormat:@"%@", name];
        //NSLog(@"%@", searchname);
        NSString* sql_main = @"SELECT event.event_id, event.time, event.name, event.value FROM event %@ ORDER BY datetime(event.time) DESC %@";
        NSString* sql_condition;
        if( name!=nil ) {
            if( start!=nil && end!=nil ) {
                sql_condition = @"WHERE name == ? AND datetime(time) >= ? AND datetime(time) < ?";
            }
            else if( start!=nil ) {
                sql_condition = @"WHERE name == ? AND datetime(time) >= ?";
            }
            else if( end!=nil ) {
                sql_condition = @"WHERE name == ? AND datetime(time) < ?";
            }
            else {
                sql_condition = @"WHERE name == ?";
            }
        }
        else {
            if( start!=nil && end!=nil ) {
                sql_condition = @"WHERE datetime(time) >= ? AND datetime(time) < ?";
            }
            else if( start!=nil ) {
                sql_condition = @"WHERE datetime(time) >= ?";
            }
            else if( end!=nil ) {
                sql_condition = @"WHERE datetime(time) < ?";
            }
            else {
                sql_condition = @"";
            }
        }
        NSString* sql_limit = @"";
        if( limit > 0 ) {
            if( offset > 0 )
                sql_limit = @"LIMIT ?,?";
            else
                sql_limit = @"LIMIT ?";
        }
        
        NSString* sql = [NSString stringWithFormat:sql_main, sql_condition, sql_limit];
        //NSLog(@"[db] SQL=%@", sql);
        
        const char *sqlz = [sql cStringUsingEncoding:NSASCIIStringEncoding];
        if(sqlite3_prepare_v2(db, sqlz, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return events;
        }
        int param_cnt = 0;
        if( name != nil ) {
            param_cnt++;
            int ret = sqlite3_bind_text(stmt, param_cnt, [searchname UTF8String], -1, SQLITE_TRANSIENT);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        }
        if( start != nil ) {
            param_cnt++;
            int ret = sqlite3_bind_text(stmt, param_cnt, [[totEvent formatTime:start] UTF8String], -1, SQLITE_TRANSIENT);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        }
        if( end != nil ) {
            param_cnt++;
            int ret = sqlite3_bind_text(stmt, param_cnt, [[totEvent formatTime:end] UTF8String], -1, SQLITE_TRANSIENT);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        }
        if( limit > 0 ) {
            if( offset > 0 ) {
                param_cnt++;
                int ret = sqlite3_bind_int(stmt, param_cnt, offset);
                if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_int %d", ret);
            }
            param_cnt++;
            int ret = sqlite3_bind_int(stmt, param_cnt, limit);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_int %d", ret);
        }
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            int i = sqlite3_column_int(stmt, 0);
            NSString *time  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 1)];
            NSString *name  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 2)];
            NSString *value = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 3)];
            //NSLog(@"[db] record, %d, %@", i, value);
            
            totEvent *e = [[totEvent alloc] init];
            e.event_id = i;
            e.baby_id = baby_id;
            e.name = name;
            e.value = value;
            //NSLog(@"model setTimeFromText %@", time);
            [e setTimeFromText:time];
            [events addObject:e];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return events;
    }
}

// a shortcut to getItem, limit=-1, offset=-1, start and end date = nil
- (totEvent *) getItem:(int)baby_id name:(NSString*)name {
    NSArray* items = [self getItem:baby_id name:name limit:-1 offset:-1 startDate:nil endDate:nil];
    if( items.count > 0 )
        return [items objectAtIndex:0];
    else
        return nil;
}

// unlike updatePreference, this function does not update event.time
// a shortcut to getItem, limit=-1, offset=-1, start and end date = nil
- (BOOL) setItem:(int)baby_id name:(NSString*)name value:(NSDictionary*)dict {
    NSString* jsonstr = [totUtility ObjectToJSON:dict];

    int cnt = [self getEventCount:baby_id event:name];
    if( cnt == 0 ) {
        // add record
        return [self addPreference:baby_id preference:name value:jsonstr];
    }
    
    // update record
    int re = 0;
    sqlite3_stmt *stmt = nil;
    @try {
        while(true) {
            if (db == nil) {
                NSLog(@"Can't open db");
                break;
            }
            NSString* sql = @"UPDATE event SET value=? WHERE name=?";
            
            const char *sqlz = [sql cStringUsingEncoding:NSUTF8StringEncoding];
            int ret;
            ret = sqlite3_prepare_v2(db, sqlz, -1, &stmt, NULL);
            if(ret != SQLITE_OK) {
                NSLog(@"[db] Problem with prepare statement %d", ret);
                break;
            }
            ret = sqlite3_bind_text(stmt, 1, [jsonstr UTF8String], -1, SQLITE_TRANSIENT);
            if( ret != SQLITE_OK ) {
                NSLog(@"[db] getEvent bind_text %d", ret);
                break;
            }
            ret = sqlite3_bind_text(stmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
            if( ret != SQLITE_OK ) {
                NSLog(@"[db] getEvent bind_text %d", ret);
                break;
            }
            
            ret = sqlite3_step(stmt);
            if (ret==SQLITE_DONE)
                re = TRUE;
            else
                NSLog(@"[db] sqlite3_step %d", ret);
            break;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return re;
    }
}

- (BOOL) deleteItem:(int)baby_id name:(NSString*)name {
    BOOL re = FALSE;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return re;
        }
        
        const char *sql = "DELETE FROM event WHERE name = ?";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return re;
        }
        int ret = sqlite3_bind_text(stmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        if( ret!=SQLITE_OK ) NSLog(@"[db] deleteItem bind_text %d", ret);
        
        if (sqlite3_step(stmt)!=SQLITE_OK) {
            return FALSE;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return TRUE;
    }
}

// get event by event_id
- (totEvent *) getEventByID:(int)event_id {
    sqlite3_stmt *stmt = nil;
    totEvent* e = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return nil;
        }
        
        NSString* sql = [NSString stringWithFormat:@"SELECT event.event_id, event.time, event.name, event.value, event.baby_id FROM event WHERE event_id=%d", event_id];
        
        const char *sqlz = [sql cStringUsingEncoding:NSASCIIStringEncoding];
        if(sqlite3_prepare_v2(db, sqlz, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return nil;
        }

        while (sqlite3_step(stmt)==SQLITE_ROW) {
            int i = sqlite3_column_int(stmt, 0);
            NSString *time  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 1)];
            NSString *name  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 2)];
            NSString *value = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 3)];
            int baby_id = sqlite3_column_int(stmt, 4);;
            //NSLog(@"[db] record, %d, %@", i, value);
            
            e = [[totEvent alloc] init];
            e.event_id = i;
            e.baby_id = baby_id;
            e.name = name;
            e.value = value;
            //NSLog(@"model setTimeFromText %@", time);
            [e setTimeFromText:time];
            break;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return e;
    }
}

- (int) getEventCount:(int)baby_id event:(NSString*)event {
    int cnt = -1;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return cnt;
        }
        
        NSString* searchname = [NSString stringWithFormat:@"%%%@%%", event];
        const char *sql = "SELECT count(*) FROM event WHERE name LIKE ?";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return cnt;
        }
        int ret = sqlite3_bind_text(stmt, 1, [searchname UTF8String], -1, SQLITE_TRANSIENT);
        if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        
        if (sqlite3_step(stmt)==SQLITE_ROW) {
            cnt = sqlite3_column_int(stmt, 0);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return cnt;
    }
}

// get total # records in db
- (int) getDBCount {
    int cnt = -1;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return cnt;
        }
        
        const char *sql = "SELECT count(*) FROM event";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return cnt;
        }

        if (sqlite3_step(stmt)==SQLITE_ROW) {
            cnt = sqlite3_column_int(stmt, 0);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return cnt;
    }
}

- (BOOL) deleteEvents:(int)baby_id event:(NSString*)event {
    BOOL re = FALSE;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return re;
        }
        
        NSString* searchname = [NSString stringWithFormat:@"%%%@%%", event];
        const char *sql = "DELETE FROM event WHERE name LIKE ?";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return re;
        }
        int ret = sqlite3_bind_text(stmt, 1, [searchname UTF8String], -1, SQLITE_TRANSIENT);
        if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        
        if (sqlite3_step(stmt)!=SQLITE_OK) {
            return FALSE;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return TRUE;
    }
}

// delete event by id
- (BOOL) deleteEventById:(int)event_id {
    BOOL re = FALSE;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return re;
        }
        
        const char *sql = "DELETE FROM event WHERE event_id = ?";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return re;
        }
        int ret = sqlite3_bind_int(stmt, 1, event_id);
        if( ret!=SQLITE_OK ) NSLog(@"[db] deleteEventById bind_int %d", ret);
        
        if (sqlite3_step(stmt)!=SQLITE_DONE) {
            int code = sqlite3_errcode(db);
            NSLog(@"[db]Error in sqlite3_step/deleteEventById: %d %s", code, sqlite3_errmsg(db));
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return TRUE;
    }
}

// clear all records in the database
- (BOOL) clearDB {
    BOOL re = FALSE;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return re;
        }
        
        const char *sql = "DELETE FROM event";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return re;
        }
        
        if (sqlite3_step(stmt)!=SQLITE_OK) {
            return FALSE;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return TRUE;
    }
}

// reset the database for factory mode, which may contains some records for development/testing
- (void) resetDB {
    // simply copy the db
    [self CopyDbToDocumentsFolder];
}

+ (void) printEvents:(NSMutableArray*)events {
    if( events == nil ) {
        NSLog(@"[printEvents] events is nil");
        return;
    }
    if( [events count] == 0 ) {
        NSLog(@"[printEvents] No events to print");
        return;
    }
    NSLog(@"[printEvents] %d events", [events count]);
    NSLog(@"--------");
    for (totEvent* e in events) {
        NSLog(@"%@", [e toString]);
    }
    NSLog(@"--------\n");
}

// get next baby id for creating a new baby profile
// TODO return first id if error occurs, this behavior probably should be changed
- (int) getNextBabyID {
    int nextid = PREFERENCE_NO_BABY + 1;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return nextid;
        }
        
        const char *sql = "SELECT MAX(baby_id) FROM event";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return nextid;
        }
        if (sqlite3_step(stmt)==SQLITE_ROW) {
            nextid = sqlite3_column_int(stmt, 0)+1;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return nextid;
    }
}

// get # accounts
- (int) getAccountCount {
    int cnt = 0;
    //cnt = [self getEventCount:PREFERENCE_NO_BABY event:PREFERENCE_ACCOUNT_QUERY];
    return [self getPreferenceNoBabyCount:PREFERENCE_ACCOUNT_QUERY];
}

+ (int)getSecondsSince1970 {
    return (int)[[NSDate date] timeIntervalSince1970];
}
@end
