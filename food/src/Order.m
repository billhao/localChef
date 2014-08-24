//
//  Order.m
//  food
//
//  Created by Hao Wang on 8/15/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "Order.h"
#import "totUtility.h"

@implementation Order

-(id) initWithDict:(NSDictionary*)dict {
    self = [super init];
    if( self && dict != nil ) {
        self.order_id       = dict[@"order_id"];
        //self.created_at     = [totUtility stringToDate:dict[@"created_at"]];
        self.order_status   = dict[@"order_status"];
        self.food           = [FoodItem fromDictionary:dict[@"item"] food_id:@"food-id"];
        self.seller         = [[totUser alloc] initWithDict:dict[@"seller"]];
        self.buyer          = [[totUser alloc] initWithDict:dict[@"buyer"]];
    }
    return self;
}

-(NSDictionary*) toDictionary {
    NSMutableDictionary* d = [[NSMutableDictionary alloc] init];
    d[@"order_id"] = self.order_id;
    d[@"order_status"] = self.order_status;
    return d;
}

@end
