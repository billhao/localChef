//
//  AppDelegate.h
//  food
//
//  Created by Hao Wang on 6/18/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NotificationManager* nm;
}

@property (strong, nonatomic) UIWindow *window;

- (void)initNotification;

@end
