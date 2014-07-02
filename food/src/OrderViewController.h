//
//  OrderViewController.h
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
- (IBAction)payButton:(UIButton *)sender;

@end
