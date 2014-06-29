//
//  FoodItemView.h
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodItem.h"

@interface FoodItemView : UIView

@property(nonatomic, retain) FoodItem* food;

- (id)initWithFrame:(CGRect)frame food:(FoodItem*)foodItem;

@end
