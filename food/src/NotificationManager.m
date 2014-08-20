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
#import "MasterViewController.h"
#import "PublishViewController.h"

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

// source:
// 1. app was not running
// 2. app is active
// 3. other - inactive or background
-(void) processNotification:(NSDictionary*)dict source:(int)source {
    int type = 0;
    if( dict != nil && dict[@"aps"] != nil && dict[@"aps"][@"type"] != nil )
        type = [dict[@"aps"][@"type"] intValue];

    NSLog(@"source=%d type=%d\n%@", source, type, dict);

    if( source == 1 && global.user != nil ) {
        if( type == 2 ) {
            // seller confirmed an order, go to buyer's order page
            NSLog(@"go to buyer's order page");
            UINavigationController* root = (UINavigationController*)[totUtility getAppDelegate].window.rootViewController;
            UIViewController* vc = root.topViewController;
            if( [vc isKindOfClass:MasterViewController.class] ) {
                [vc performSegueWithIdentifier:@"goToBuyerOrderListPage" sender:root];
            }
        }
        else if( type == 1 || type == 3 ) {
            // go to seller's order page
            NSLog(@"go to seller's order page");
            AppDelegate* app = [totUtility getAppDelegate];
            UIStoryboard *storyboard = app.window.rootViewController.storyboard;
            UINavigationController *sellerNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"sellerNavigationController"];
            app.window.rootViewController = sellerNavigationController;
            UIViewController* vc = sellerNavigationController.topViewController;
            if( [vc isKindOfClass:PublishViewController.class] ) {
                [vc performSegueWithIdentifier:@"goToSellerOrderListPage" sender:sellerNavigationController];
            }
            

        }
    }
}

-(NSString*)tokenToString:(NSData*)devToken {
    NSString *newToken = [devToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
	//NSLog(@"My token is: %@", newToken);
    return newToken;
}

@end
