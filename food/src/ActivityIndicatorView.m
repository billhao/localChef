//
//  AcitivityIndicatorView.m
//  food
//
//  Created by Hao Wang on 9/13/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "ActivityIndicatorView.h"

@implementation ActivityIndicatorView

-(void)viewDidLoad {
    self.view.hidden = true;
    self.view.frame = CGRectMake(0, 0, 120, 120);
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 10.0;
    
    ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    ai.hidesWhenStopped = true;
    [self.view addSubview:ai];
    CGPoint center = self.view.center;
    center.y = 50;
    ai.center = center;

    text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    text.text = @"Loading...";
    text.backgroundColor = [UIColor clearColor];
    text.textColor = [UIColor whiteColor];
    text.font = [UIFont fontWithName:@"Helvetica Neue Thin" size:16];
    text.textAlignment = NSTextAlignmentCenter;
    text.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:text];
    center.y = 90;
    text.center = center;
}

-(void) start {
    CGPoint center = self.view.superview.center;
    center.y = center.y * 2 / 3; // place the indicator at 1/3 of parent view's height
    self.view.center = center;
    [ai startAnimating];
    self.view.hidden = false;
}

-(void) stop {
    [ai stopAnimating];
    self.view.hidden = true;
}

@end
