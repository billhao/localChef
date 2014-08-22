//
//  MenuCell.h
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *f_image;
@property (weak, nonatomic) IBOutlet UILabel *f_name;
@property (weak, nonatomic) IBOutlet UITextView *f_desc;
@property (weak, nonatomic) IBOutlet UILabel *f_price;



@end
