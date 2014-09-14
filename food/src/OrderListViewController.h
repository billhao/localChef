//
//  OrderViewController.h
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityIndicatorView.h"

@interface OrderListViewController : UITableViewController {
    NSMutableArray* orders;

    // UI
    UILabel* noItemLabel;
    //ActivityIndicatorView* activityIndicator;
}

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
- (IBAction)payButton:(UIButton *)sender;
- (IBAction)removeButtonPressed:(UIButton *)sender;

@end
