// a totEvent object represents a single event
// see test_Model.m for an exmaple
// Created by Hao on 4/22/12.

#import <Foundation/Foundation.h>

@interface totEvent : NSObject {
    int      event_id;
    int      baby_id;
    NSDate   *datetime;
    NSString *name;
    NSString *value;
}

@property (nonatomic) int      event_id;
@property (nonatomic) int      baby_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSDate   *datetime;

// return datetime of the event in string
-(NSString*) getTimeText;

// set datetime from a string
-(NSDate*) setTimeFromText:(NSString*)dt;

// return the event as a string
-(NSString*) toString;

// helper functions to convert between date and string
+(NSDate*) dateFromString:(NSString*)datetime;
+(NSString*) formatTime:(NSDate*)datetime;

@end
