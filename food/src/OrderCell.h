//
//  OrderCell.h
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *f_image;
@property (weak, nonatomic) IBOutlet UILabel *f_name;
@property (weak, nonatomic) IBOutlet UILabel *f_desc;
@property (weak, nonatomic) IBOutlet UIButton *f_price;

@end
