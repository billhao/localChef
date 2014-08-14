//
//  totURLConnection.m
//  totdev
//
//  Created by Hao Wang on 1/29/14.
//  Copyright (c) 2014 tot. All rights reserved.
//

#import "totURLConnection.h"

@implementation totURLConnection

@synthesize responseData, finished;

- (id)initWithRequest:(NSURLRequest *)request
             delegate:(id)delegate
     startImmediately:(BOOL)startImmediately
             callback:(totURLConnectionCallback)callback {
    if( self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately] ) {
        self.callback = callback;
        self.finished = FALSE;
    }
    return self;
}

@end
