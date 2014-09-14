//
//  AcitivityIndicatorView.h
//  food
//
//  Created by Hao Wang on 9/13/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorView : UIViewController {
    UIActivityIndicatorView* ai;
    UILabel* text;

}

-(void) start;
-(void) stop;

@end
