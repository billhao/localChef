//
//  Global.h
//  totdev
//
//  Created by Hao Wang on 1/3/13.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodItem.h"

@interface Global : NSObject

@property (nonatomic, retain, readonly) NSMutableArray *order;

@end

extern Global* global;

