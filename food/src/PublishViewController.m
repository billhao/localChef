//
//  PublishViewController.m
//  food
//
//  Created by Hao Wang on 7/10/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "PublishViewController.h"
#import "Global.h"
#import "totUtility.h"

@interface PublishViewController ()

@end

@implementation PublishViewController

@synthesize food_price, food_name, food_image, food_quantity, food_start_time, food_time,
    quantityStepper, priceStepper, timeStepper, seller_address, seller_location;

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
    food_name.delegate = self;
    food_start_time.delegate = self;
    food_time.delegate = self;
    seller_location.delegate = self;
    seller_address.delegate = self;

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
    // verify the input
    if( food_name.text.length == 0 ) {
        [totUtility showAlert:@"Food name is empty!"];
        return;
    }
    
    FoodItem* item = [[FoodItem alloc] init];
    
    item.food_name = food_name.text;
    
    // send the order to server
    item.food_id = [global.server publishItem:item];
    
    // publish completed. publish more or go to the list of published items
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Item published successfully"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Publish more", @"Done", nil];
    [alert show];
}

#pragma mark - event handlers
- (IBAction)quantityTextValueChanged:(UITextField *)sender {
    quantityStepper.value = [sender.text intValue];
}

- (IBAction)priceTextValueChanged:(UITextField *)sender {
    priceStepper.value = [sender.text intValue];
}

- (IBAction)timeTextValueChanged:(UITextField *)sender {
    timeStepper.value = [sender.text intValue];
}

- (IBAction)foodNameTextValueChanged:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self publishMore];
    }
    else if(buttonIndex == 1)
    {
        // go to the published item list page
    }
}

#pragma mark - helper functions

- (void)publishMore {
    // if publish more, clean content of this page
    [self cleanContent];
//    seller_address.text = item.seller_address;
//    seller_location.text = item.seller_location;
}

- (void)cleanContent {
    food_name.text = @"";
    food_quantity.text = @"";
    food_price.text = @"";
    food_start_time.text = @"";
    food_time.text = @"";
    //seller_location.text = @"";
    //seller_address.text = @"";
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//
//    [food_quantity resignFirstResponder];
//}

@end
