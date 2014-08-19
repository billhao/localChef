//
//  NotificationManager.m
//  food
//
//  Created by Hao Wang on 8/18/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "NotificationManager.h"
#import "Global.h"
#import "totUtility.h"

@implementation NotificationManager

-(void) register {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

-(void) updateDeviceToken:(NSData*)devToken {
    NSString* token = [self tokenToString:devToken];
    NSLog(@"new device token = %@", token);
    
    NSString* oldToken = [totUtility getSetting:@"deviceToken"];
    if( ![oldToken isEqualToString:token] ) {
        BOOL re = [global.server updateDeviceToken:token];
        if( re ) {
            [totUtility setSetting:@"deviceToken" value:token];
        }
        else
            NSLog(@"update device token failed");
    }
}

-(void) processNotification:(NSDictionary*)dict {
    NSLog(@"%@", dict);
}

-(NSString*)tokenToString:(NSData*)devToken {
    NSString *newToken = [devToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
	//NSLog(@"My token is: %@", newToken);
    return newToken;
}

@end
