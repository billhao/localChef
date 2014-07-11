//
//  totURLConnection.h
//  totdev
//
//  Created by Hao Wang on 1/29/14.
//  Copyright (c) 2014 tot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^totURLConnectionCallback) (int ret, NSString* msg);

@interface totURLConnection : NSURLConnection {}

- (id)initWithRequest:(NSURLRequest *)request
             delegate:(id)delegate
     startImmediately:(BOOL)startImmediately
             callback:(totURLConnectionCallback)callback;

@property(nonatomic, retain) NSMutableData *responseData;
@property(copy) totURLConnectionCallback callback ;
@property(nonatomic,assign) BOOL finished;

@end
