//
//  FoodItem.h
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodItem : NSObject

// seller
@property(nonatomic, retain) NSString*  seller_id;
@property(nonatomic, retain) NSString*  seller_name;
@property(nonatomic, retain) NSString*  seller_address;
@property(nonatomic, retain) NSString*  seller_location;
@property(nonatomic, retain) NSString*  seller_phone;

// food
@property(nonatomic, retain) NSString*  food_id;
@property(nonatomic, retain) NSString*  food_name;
@property(nonatomic, retain) NSString*  food_description;
@property(nonatomic, retain) NSString*  food_image_url;
@property(nonatomic, assign) double     food_price;
@property(nonatomic, assign) long       food_quantity;
@property(nonatomic, retain) NSDate*    food_start_time;
@property(nonatomic, retain) NSDate*    food_end_time;

// pickup/delivery

+ (FoodItem*)getRandomFood;

- (void)toString;

+ (FoodItem*)fromDictionary:(NSDictionary*)item food_id:(NSString*)food_id;
+ (NSDictionary*)toDictionary:(FoodItem*)item;

@end
