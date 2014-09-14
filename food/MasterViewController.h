//
//  MasterViewController.h
//  food
//
//  Created by Hao Wang on 6/18/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodItem.h"
#import "ActivityIndicatorView.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController<UISearchBarDelegate, UIAlertViewDelegate> {
    FoodItem* currentOrder;
    
    // UI
    UILabel* noItemLabel;
    //ActivityIndicatorView* activityIndicator;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) DetailViewController *detailViewController;



- (IBAction)addToOrder:(UIButton *)sender;


@end
