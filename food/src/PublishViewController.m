//
//  PublishViewController.m
//  food
//
//  Created by Hao Wang on 7/10/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "PublishViewController.h"

@interface PublishViewController ()

@end

@implementation PublishViewController

@synthesize food_price, food_name, food_image, food_quantity, food_start_time, food_time,
    quantityStepper, priceStepper, timeStepper;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)timeValueChanged:(UIStepper *)sender {
    food_time.text = [NSString stringWithFormat:@"%.0f", sender.value];
}

- (IBAction)priceValueChanged:(UIStepper *)sender {
    food_price.text = [NSString stringWithFormat:@"%.2f", sender.value];
}

- (IBAction)quantityValueChanged:(UIStepper *)sender {
    food_quantity.text = [NSString stringWithFormat:@"%.0f", sender.value];
}

- (IBAction)publish:(UIButton *)sender {
}

- (IBAction)quantityTextValueChanged:(UITextField *)sender {
    quantityStepper.value = [sender.text intValue];
}

- (IBAction)priceTextValueChanged:(UITextField *)sender {
    priceStepper.value = [sender.text intValue];
}

- (IBAction)timeTextValueChanged:(UITextField *)sender {
    timeStepper.value = [sender.text intValue];
}
@end
