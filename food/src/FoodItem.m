//
//  FoodItem.m
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "FoodItem.h"

@implementation FoodItem

+ (FoodItem*)getRandomFood {
    FoodItem* f = [[FoodItem alloc] init];
//    return f;
    
    int i = arc4random_uniform(4);
    i = 0;
    if( i == 0 ) {
        f.food_id = @"1";
        f.food_name = @"红烧肉";
        f.food_description = @"不好吃不要钱";
        f.food_image_url = @"rou";
        f.food_quantity = 2;
        f.food_price = 20;
        f.food_start_time = [NSDate date];
        f.food_end_time = [NSDate dateWithTimeIntervalSinceNow:3600];
        f.seller_name = @"王阿姨";
        f.seller_id = 1;
        f.seller_address = @"王府井1号";
        f.seller_location = @"95123";
        f.seller_phone = @"13810018888";
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
    NSLog(@"%ld %@ %@ %.0f", self.food_id, self.food_name, self.seller_name, self.food_price);
}

@end
