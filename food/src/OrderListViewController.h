//
//  OrderViewController.h
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UITableViewController {
    NSMutableArray* orders;
}

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
- (IBAction)payButton:(UIButton *)sender;
- (IBAction)removeButtonPressed:(UIButton *)sender;

@end
