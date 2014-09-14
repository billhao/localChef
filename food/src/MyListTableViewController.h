//
//  MyListTableViewController.h
//  food
//
//  Created by Hao Wang on 7/31/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityIndicatorView.h"

@interface MyListTableViewController : UITableViewController {
    // UI
    //ActivityIndicatorView* activityIndicator;

}

- (IBAction)goToMyList:(UIStoryboardSegue *)segue;
- (IBAction)confirmOrder:(UIButton*)sender;

@end
