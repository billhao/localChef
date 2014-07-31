//
//  PublishViewController.h
//  food
//
//  Created by Hao Wang on 7/10/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <UIKit/UIKit.h>

#define oneHour 3600 // one hour in seconds

@interface PublishViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSDate* start_time;
    NSDate* end_time;
    UIImagePickerController *imagePicker;

    // for scrolling & keyboard
    UIView* activeTextField;
    UIEdgeInsets contentInset;
    UIEdgeInsets scrollIndicatorInsets;

    bool keyboardShown;
}

// steppers
- (IBAction)timeValueChanged:(UIStepper *)sender;
- (IBAction)priceValueChanged:(UIStepper *)sender;
- (IBAction)quantityValueChanged:(UIStepper *)sender;

- (IBAction)publish:(UIButton *)sender;

// text boxes
- (IBAction)foodNameTextValueChanged:(UITextField *)sender;
- (IBAction)quantityTextValueChanged:(UITextField *)sender;
- (IBAction)priceTextValueChanged:(UITextField *)sender;
- (IBAction)timeTextValueChanged:(UITextField *)sender;
- (IBAction)locationTouchUpInside:(id)sender;
- (IBAction)takePhotoButtonPressed:(UIButton *)sender;

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)textField;

- (IBAction)textFieldReturn:(UITextField *)sender;

@property (weak, nonatomic) IBOutlet UITextView *food_description;
@property (weak, nonatomic) IBOutlet UITextField *seller_phone;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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

@property (strong, nonatomic) NSArray *locations;

@end
