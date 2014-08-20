//
//  NotificationManager.h
//  food
//
//  Created by Hao Wang on 8/18/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

-(void) register;
-(void) updateDeviceToken:(NSData*)devToken;
-(void) processNotification:(NSDictionary*)dict source:(int)source;

@end
