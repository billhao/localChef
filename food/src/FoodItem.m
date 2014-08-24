//
//  FoodItem.m
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "FoodItem.h"
#import "totUtility.h"

@implementation FoodItem

-(id) init{
    self = [super init];
    if( self ) {
        self.orders = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (FoodItem*)getRandomFood {
    FoodItem* f = [[FoodItem alloc] init];
//    return f;
    
    int i = arc4random_uniform(4);
    i = 0;
    if( i == 0 ) {
        f.food_id = @"1";
        f.food_name = @"Fried fish";
        f.food_description = @"Delicious fish";
        f.food_image_url = @"fish";
        f.food_quantity = 2;
        f.food_price = 12;
        f.food_start_time = [NSDate date];
        f.food_end_time = [NSDate dateWithTimeIntervalSinceNow:3600];
        f.seller_name = @"Hao Wang";
        f.seller_id = @"1";
        f.seller_address = @"Blossom Hill Rd and Lean Ave";
        f.seller_location = @"95123";
        f.seller_phone = @"2139059092";
    }
//    else if( i == 1 ) {
//        f.food_id = 2;
//        f.food_name = @"清蒸鲈鱼";
//        f.food_description = @"清蒸鲈鱼，味道绝对好";
//        f.food_image_url = @"fish";
//        f.seller = @"王阿姨";
//        f.seller_id = 1;
//        f.address = @"王府井1号";
//        f.phone = @"13810018888";
//        f.quantity = 1;
//        f.price = 38;
//        f.start_time = [NSDate date];
//        f.end_time = [NSDate dateWithTimeIntervalSinceNow:3600];
//    }
//    else if( i == 2 ) {
//        f.food_id = 3;
//        f.food_name = @"麻婆豆腐";
//        f.food_image_url = @"rou";
//        f.food_description = @"";
//        f.seller = @"张阿姨";
//        f.seller_id = 2;
//        f.address = @"张家界288号";
//        f.phone = @"13288888888";
//        f.quantity = 3;
//        f.price = 16;
//        f.start_time = [NSDate date];
//        f.end_time = [NSDate dateWithTimeIntervalSinceNow:3600];
//    }
//    else if( i == 3 ) {
//        f.food_id = 4;
//        f.food_name = @"清炒小菜";
//        f.food_description = @"";
//        f.food_image_url = @"fish";
//        f.seller = @"李阿姨";
//        f.seller_id = 3;
//        f.address = @"人民路122号";
//        f.phone = @"86579421";
//        f.quantity = 5;
//        f.price = 12;
//        f.start_time = [NSDate date];
//        f.end_time = [NSDate dateWithTimeIntervalSinceNow:3600];
//    }
    return f;
}

- (void)toString {
    NSLog(@"%@ %@ %@ %.0f", self.food_id, self.food_name, self.seller_name, self.food_price);
}

+ (FoodItem*)fromDictionary:(NSDictionary*)item food_id:(NSString*)food_id {
    FoodItem* food = [[FoodItem alloc] init];
    food.food_id            = food_id;
    food.food_name          = item[@"food_name"];
    food.food_description   = item[@"food_description"];
    food.food_price         = [item[@"food_price"] doubleValue];
    food.food_quantity      = [item[@"food_quantity"] integerValue];
    food.food_start_time    = [totUtility stringToDateFull:item[@"food_start_time"]];
    food.food_end_time      = [totUtility stringToDateFull:item[@"food_end_time"]];
    if( item[@"food_image_url"] != nil && [item[@"food_image_url"] length] > 0 ) {
        UIImage* img = [totUtility stringToImage:item[@"food_image_url"]];
        NSString* path = [totUtility saveImage:img filename:food.food_name];
        food.food_image_url = path;
    }
    return food;
}

+ (NSDictionary*)toDictionary:(FoodItem*)food {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    dict[@"seller_id"]          = food.seller_id;
    dict[@"seller_name"]        = food.seller_name;
    dict[@"seller_address"]     = food.seller_address;
    dict[@"seller_location"]    = food.seller_location;
    dict[@"seller_phone"]       = food.seller_phone;
    
    dict[@"food_name"]          = food.food_name;
    dict[@"food_description"]   = food.food_description;
    dict[@"food_image_url"]     = @"";//[totUtility imageToString:[UIImage imageNamed:food.food_image_url]];
    dict[@"food_price"]         = [NSNumber numberWithDouble:food.food_price];
    dict[@"food_quantity"]      = [NSNumber numberWithLong:food.food_quantity];
    dict[@"food_start_time"]    = [totUtility dateToStringFull:food.food_start_time];
    dict[@"food_end_time"]      = [totUtility dateToStringFull:food.food_end_time];

    if( food.food_id != nil )
        dict[@"food_id"]        = food.food_id;
    
    return dict;
}

@end
