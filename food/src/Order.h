//
//  Order.h
//  food
//
//  Created by Hao Wang on 8/15/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodItem.h"
#import "totUser.h"

#define ORDER_STATUS_ORDERED    @"ordered"
#define ORDER_STATUS_CONFIRMED  @"confirmed"
#define ORDER_STATUS_COMPLETED  @"completed"

@interface Order : NSObject

@property(nonatomic, retain) NSString* order_id;
@property(nonatomic, retain) NSDate*   created_at;
@property(nonatomic, retain) NSString* order_status;
@property(nonatomic, retain) FoodItem* food;
@property(nonatomic, retain) totUser*  seller;
@property(nonatomic, retain) totUser*  buyer;

-(id) initWithDict:(NSDictionary*)dict;
-(NSDictionary*) toDictionary;

@end
