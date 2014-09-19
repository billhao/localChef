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
#import "MenuViewController.h"

@implementation NotificationManager

-(void) register {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

-(void) updateDeviceToken:(NSData*)devToken {
    NSString* token = [self tokenToString:devToken];
    printfm(@"received device token = %@", token);
    
    NSString* oldToken = [totUtility getSetting:@"deviceToken"];
    NSString* oldTokenUser = [totUtility getSetting:@"deviceTokenUser"];
    if( !([oldToken isEqualToString:token] && [oldTokenUser isEqualToString:global.user.id_str] ) ) {
        NSLog(@"new device token = %@", token);
        BOOL re = [global.server updateDeviceToken:token];
        if( re ) {
            [totUtility setSetting:@"deviceToken" value:token];
            [totUtility setSetting:@"deviceTokenUser" value:global.user.id_str];
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
    if( dict != nil && dict[@"type"] != nil )
        type = [dict[@"type"] intValue];

    NSLog(@"Received notification source=%d type=%d\n%@", source, type, dict);
    return; // do not handle push notification until i find out how to go to the correct view

    if( (source == 1 || source == 3) && global.user != nil ) {
        if( type == 2 ) {
            // seller confirmed an order, go to buyer's order page
            NSLog(@"go to buyer's order page");
            UIViewController* vc = [totUtility getAppDelegate].window.rootViewController;
            print([vc.class description]);
            //UINavigationController* root = (UINavigationController*)[totUtility getAppDelegate].window.rootViewController;
            //UIViewController* vc = root.topViewController;
            if( [vc isKindOfClass:MenuViewController.class] ) {
                [vc performSegueWithIdentifier:@"goToBuyerOrderListPage" sender:vc];
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
    else if (source == 2 && global.user != nil ) {
        
    }
}

-(NSString*)tokenToString:(NSData*)devToken {
    NSString *newToken = [devToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
	//NSLog(@"My token is: %@", newToken);
    return newToken;
}

- (void)clearBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end
