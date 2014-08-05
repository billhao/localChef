//
//  Global.m
//  totdev
//
//  Created by Hao Wang on 1/3/13.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import "Global.h"

@implementation Global

@synthesize order, server, myPublishItems, user;

Global* global = nil;

// override
- (id)init {
    if( self = [super init] ) {
        order = [[NSMutableArray alloc] init];
        myPublishItems = [[NSMutableArray alloc] init];
        server = [[totServerCommController alloc] init];
        user = nil;
    }
    return self;
}

@end
