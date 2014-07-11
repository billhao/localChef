//
//  Base64Encoder.h
//  tot_server
//
//  Created by User on 10/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Encoder : NSObject {}

+(NSString *)encode:(NSData *)plainText;

@end
