//
//  PublishViewController.h
//  food
//
//  Created by Hao Wang on 7/10/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishViewController : UIViewController

// steppers
- (IBAction)timeValueChanged:(UIStepper *)sender;
- (IBAction)priceValueChanged:(UIStepper *)sender;
- (IBAction)quantityValueChanged:(UIStepper *)sender;

- (IBAction)publish:(UIButton *)sender;

// text boxes
- (IBAction)quantityTextValueChanged:(UITextField *)sender;
- (IBAction)priceTextValueChanged:(UITextField *)sender;
- (IBAction)timeTextValueChanged:(UITextField *)sender;

@property (weak, nonatomic) IBOutlet UITextField *food_name;
@property (weak, nonatomic) IBOutlet UITextField *food_quantity;
@property (weak, nonatomic) IBOutlet UITextField *food_price;
@property (weak, nonatomic) IBOutlet UITextField *food_start_time;
@property (weak, nonatomic) IBOutlet UITextField *food_time;
@property (weak, nonatomic) IBOutlet UITextField *seller_address;
@property (weak, nonatomic) IBOutlet UITextField *seller_location;
@property (weak, nonatomic) IBOutlet UIImageView *food_image;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (weak, nonatomic) IBOutlet UIStepper *priceStepper;
@property (weak, nonatomic) IBOutlet UIStepper *timeStepper;

@end
