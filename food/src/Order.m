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
//        self.seller         = dict[@"seller"];
//        self.buyer          = dict[@"buyer"];
    }
    return self;
}

@end
