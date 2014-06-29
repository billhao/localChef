//
//  FoodItemView.m
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "FoodItemView.h"

@implementation FoodItemView

@synthesize food;

- (id)initWithFrame:(CGRect)frame food:(FoodItem*)foodItem
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        food = foodItem;
        UILabel* title = [[UILabel alloc] init];
        title.text = food.name;
        [title setText:food.name];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
