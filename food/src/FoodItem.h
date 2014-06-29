//
//  FoodItem.h
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodItem : NSObject

@property(nonatomic, assign) NSInteger  id;
@property(nonatomic, retain) NSString*  name;
@property(nonatomic, retain) NSString*  description;
@property(nonatomic, retain) NSString*  image_url;
@property(nonatomic, retain) NSString*  seller;
@property(nonatomic, assign) NSInteger  seller_id;
@property(nonatomic, retain) NSString*  address;
@property(nonatomic, retain) NSString*  phone;
@property(nonatomic, assign) float      price;
@property(nonatomic, assign) int        quantity;
@property(nonatomic, retain) NSDate*    start_time;
@property(nonatomic, retain) NSDate*    end_time;

+ (FoodItem*)getRandomFood;

- (void)toString;

@end
