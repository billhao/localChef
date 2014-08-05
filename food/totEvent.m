//
//  totEvent.m
//  totdev
//
//  Created by Hao on 4/22/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totEvent.h"
#import <time.h>
#import <xlocale.h>

@implementation totEvent

@synthesize event_id, baby_id, name, value, datetime;

-(NSString*) getTimeText {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    NSString *formattedDateString = [dateFormatter stringFromDate:datetime];
    //NSLog(@"formattedDateString: %@", formattedDateString);
    
    return formattedDateString;
}

+(NSString*) formatTime:(NSDate*)datetime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:datetime];

    return formattedDateString;
}

+(NSDate*) dateFromString:(NSString*)datetime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:datetime];

    return date;
}

-(NSDate*) setTimeFromText:(NSString*)dt {
    self.datetime = [totEvent dateFromString:dt];
    return datetime;
}

-(NSString*) toString {
    return [NSString stringWithFormat:@"%d\t%d\t%@\t%@\t%@", event_id, baby_id, [self getTimeText], name, value];
}

- (id)copy {
    totEvent* e = [[totEvent alloc] init];
    e.event_id = event_id;
    e.baby_id = baby_id;
    e.datetime = datetime;
    e.name = name;
    e.value = value;
    return e;
}

- (BOOL)isEqual:(id)object {
    if( ![object isKindOfClass:totEvent.class] ) return FALSE;
    
    totEvent* e1 = (totEvent*)object;
    if( event_id == e1.event_id && [datetime isEqualToDate:e1.datetime] )
        return TRUE;
    else
        return FALSE;
}

@end
