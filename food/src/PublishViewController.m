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
    quantityStepper, priceStepper, timeStepper, seller_address, seller_location, scrollView,
    publishButton, locations, startTimePicker, endTimePicker, takePhotoButton,
    food_description;

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

    activeTextField = nil;
    
    // init the input fields
    // price
    food_price.text = @"$ 5";
    priceStepper.value = 5.0;
    seller_address.text = @"";
    food_name.text = @"";
    
    // add border to description box
    food_description.layer.borderWidth = 0.5;
    food_description.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    food_description.layer.cornerRadius = 4;
    food_description.clipsToBounds = true;
    
    // load last address & location
    NSString* lastAddress = [totUtility getSetting:@"lastAddress"];
    NSString* lastLocation = [totUtility getSetting:@"lastLocation"];
    if( lastAddress != nil && lastAddress.length > 0 )
        seller_address.text = lastAddress;
    if( lastLocation != nil && lastLocation.length > 0 )
        seller_location.text = lastLocation;
    
    // location
//    locations = @[@"Mountain View, CA",
//                  @"Blossom Hill, San Jose, CA"
//                  ];
//    seller_location.inputView = locationPicker;
//    seller_location.inputAccessoryView = [self createInputAccessoryView];
//    seller_location.text = locations[0];
    
    seller_location.inputAccessoryView = [self createInputAccessoryView];
    food_description.inputAccessoryView = [self createInputAccessoryView];

    // start time
    start_time = nil;
    end_time = nil;

    [self createDatePicker];
    
    UIView* doneButton = [self createInputAccessoryView1];
    food_start_time.inputView = startTimePicker;
    food_start_time.inputAccessoryView = doneButton;
//    NSDate* d1 = [NSDate date];
//    NSDate* d2 = [NSDate dateWithTimeIntervalSinceNow: oneHour * 24 * 3]; // 3 days from now
//    startTimePicker.date = d1;
//    startTimePicker.minimumDate = d1;
////    startTimePicker.maximumDate = d1;
    [self startTimePickerDoneClicked:nil];
    
    // end time
    UIView* doneButton2 = [self createInputAccessoryView2];
    food_time.inputView = endTimePicker;
    food_time.inputAccessoryView = doneButton2;
//    endTimePicker.minimumDate = d1;
//    endTimePicker.date = [d1 dateByAddingTimeInterval: oneHour * 3];
    [self endTimePickerDoneClicked:nil];
    
    keyboardShown = false;
    [self registerForKeyboardNotifications];
}

-(void)viewDidLayoutSubviews {
    CGRect f = scrollView.frame;
    int h = publishButton.frame.origin.y + publishButton.frame.size.height - scrollView.contentOffset.y + 60;
    [scrollView setContentSize:CGSizeMake(f.size.width, h)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)timeValueChanged:(UIStepper *)sender {
    food_time.text = [NSString stringWithFormat:@"%.0f", sender.value];
}

- (IBAction)priceValueChanged:(UIStepper *)sender {
    if( sender.value == 0 )
        food_price.text = @"Free";
    else
        food_price.text = [NSString stringWithFormat:@"$ %.0f", sender.value];
}

- (IBAction)quantityValueChanged:(UIStepper *)sender {
    food_quantity.text = [NSString stringWithFormat:@"Quantity: %.0f", sender.value];
}

// verify the input
- (BOOL)checkInput {
    int maxlen = 30; // max length
    
    if( [totUtility trimString:food_name.text].length == 0 ) {
        [totUtility showAlert:@"Please type in food name"];
        return false;
    }
    if( food_name.text.length > maxlen ) {
        [totUtility showAlert:[NSString stringWithFormat:@"Food name can't be more than %d characters", maxlen]];
        return false;
    }
    if( [totUtility trimString:seller_address.text].length == 0 ) {
        [totUtility showAlert:@"Please type in your address or location"];
        return false;
    }
    if( seller_address.text.length > maxlen ) {
        [totUtility showAlert:[NSString stringWithFormat:@"Address can't be more than %d characters", maxlen]];
        return false;
    }
    if( [totUtility trimString:seller_location.text].length == 0 ) {
        [totUtility showAlert:@"Please type in your Zip Code"];
        return false;
    }
    if( [totUtility trimString:seller_location.text].length != 5 ) {
        [totUtility showAlert:@"Zip Code must be 5 digits"];
        return false;
    }
    return true;
}

- (IBAction)publish:(UIButton *)sender {
    // verify the input
    if( ![self checkInput] ) return;
    
    FoodItem* item = [[FoodItem alloc] init];
    
    item.food_name = [totUtility trimString:food_name.text];
    item.food_description = [totUtility trimString:food_description.text];
    item.food_image_url = @"fish.jpg";
    item.food_price = [[food_price.text stringByReplacingOccurrencesOfString:@"$ " withString:@""] doubleValue];
    item.food_quantity = [[food_quantity.text stringByReplacingOccurrencesOfString:@"Quantity: " withString:@""] intValue];
    item.food_start_time = start_time;
    item.food_end_time = end_time;
    item.seller_id = global.user.id_str;
    item.seller_name = global.user.email;
    item.seller_address = seller_address.text;
    item.seller_location = seller_location.text;
    item.seller_phone = @"2139059092";//global.user.phone;
    
    // save zip code and address
    [totUtility setSetting:@"lastAddress" value:seller_address.text];
    [totUtility setSetting:@"lastLocation" value:seller_location.text];
    
    
    // send the item to server
    item.food_id = [global.server publishItem:item];
    
    // add this item to the list
    [global.myPublishItems insertObject:item atIndex:0];
    
    [self performSegueWithIdentifier:@"goToSellerOrderListPage" sender:self];
    return;
    
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

//- (IBAction)locationTouchUpInside:(id)sender {
//    // show location picker
//    CGRect f = locationPicker.frame;
//    f.origin.y = self.view.bounds.size.height;
//    locationPicker.frame = f;
//    [UIView animateWithDuration:0.4 animations:^{
//        CGRect f1 = f;
//        f1.origin.y = f1.size.height;
//        locationPicker.frame = f1;
//    }];
//}

- (IBAction)takePhotoButtonPressed:(UIButton *)sender {
    [self takePhoto];
}

- (IBAction)textFieldReturn:(UITextField *)sender {
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

- (void)createDatePicker {
    NSDate* now = [NSDate date];
    
    startTimePicker = [[UIDatePicker alloc] init];
    startTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    startTimePicker.minuteInterval = 15;
    startTimePicker.date = now;
    startTimePicker.minimumDate = now;
    startTimePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:oneHour * 24 * 7]; // 7 days from now

    endTimePicker = [[UIDatePicker alloc] init];
    endTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    endTimePicker.minuteInterval = 15;
    endTimePicker.date = [startTimePicker.date dateByAddingTimeInterval: oneHour * 5];
    endTimePicker.minimumDate = now;
    endTimePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:oneHour * 24 * 7]; // 7 days from now
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//
//    [food_quantity resignFirstResponder];
//}


#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return locations.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return locations[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    seller_location.text = locations[row];
}

- (UIView*)createInputAccessoryView{
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView	= [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle		= UIBarStyleDefault;
    keyboardDoneButtonView.translucent	= YES;
    keyboardDoneButtonView.tintColor	= nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton    = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(textFieldDoneButtonClicked:)];
    
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer1    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil action:nil];
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer, spacer1, doneButton, nil]];
    
    return keyboardDoneButtonView;
}

- (void)textFieldDoneButtonClicked: (id *)control {
    [seller_location resignFirstResponder];
    [food_description resignFirstResponder];
}

//- (void)pickerDoneClicked: (UIButton *)button {
//    [seller_location resignFirstResponder];
//    seller_location.text = locations[[locationPicker selectedRowInComponent:0]];
//}

- (UIView*)createInputAccessoryView1 {
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView	= [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle		= UIBarStyleDefault;
    keyboardDoneButtonView.translucent	= YES;
    keyboardDoneButtonView.tintColor	= nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton    = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(startTimePickerDoneClicked:)];
    
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer1    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil action:nil];
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer, spacer1, doneButton, nil]];
    
    return keyboardDoneButtonView;
}

- (void)startTimePickerDoneClicked: (UIButton *)button {
    [food_start_time resignFirstResponder];
    food_start_time.text = [NSString stringWithFormat:@"Available from %@", [totUtility dateToStringHumanReadable:startTimePicker.date]];
    start_time = startTimePicker.date;
}


- (UIView*)createInputAccessoryView2 {
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView	= [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle		= UIBarStyleDefault;
    keyboardDoneButtonView.translucent	= YES;
    keyboardDoneButtonView.tintColor	= nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton    = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(endTimePickerDoneClicked:)];
    
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer1    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil action:nil];
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer, spacer1, doneButton, nil]];
    
    return keyboardDoneButtonView;
}

- (void)endTimePickerDoneClicked: (UIButton *)button {
    [food_time resignFirstResponder];
    food_time.text = [NSString stringWithFormat:@"Until %@", [totUtility dateToStringHumanReadable:endTimePicker.date]];
    end_time = endTimePicker.date;
}

#pragma mark - Helper functions for taking photo


- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [takePhotoButton setTitle:@"" forState:UIControlStateNormal];
    [takePhotoButton setTitle:@"" forState:UIControlStateHighlighted];
    [takePhotoButton setTitle:@"" forState:UIControlStateSelected];
    takePhotoButton.backgroundColor = [UIColor clearColor];
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    food_image.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//- (void)launchCamera:(UIViewController*)vc type:(UIImagePickerControllerSourceType)type {
//    if (!imagePicker) {
//        imagePicker = [[UIImagePickerController alloc] init];
//    }
//    if ( (type == UIImagePickerControllerSourceTypeCamera) &&
//        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        imagePicker.delegate = self;
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage, nil];
//        imagePicker.allowsEditing = NO;
//        
//        // create overlay button for go to photo library
//        UIImage* photoLibImg = [UIImage imageNamed:@"photo_lib"];
//        CGRect f = CGRectMake(imagePicker.view.bounds.size.width-photoLibImg.size.width-10,
//                              imagePicker.view.bounds.size.height-photoLibImg.size.height-10-54-50,
//                              photoLibImg.size.width,
//                              photoLibImg.size.height);
//        
//        UIView *overlay_view = [[UIView alloc] initWithFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, f.size.height)];
//        overlay_view.contentMode = UIViewContentModeTop;
//        
//        UIButton* overlay = [UIButton buttonWithType:UIButtonTypeCustom];
//        // overlay.frame = f;
//        overlay.frame = CGRectMake(0, 0, f.size.width, f.size.height);
//        overlay.alpha = 0.5;
//        [overlay setImage:photoLibImg forState:UIControlStateNormal];
//        [overlay addTarget:self action:@selector(photoLibButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [overlay_view addSubview:overlay];
//        
//        // imagePicker.cameraOverlayView = overlay;
//        imagePicker.cameraOverlayView = overlay_view;
//        //UIView* v = imagePicker.cameraOverlayView;
//        //[imagePicker.cameraOverlayView addSubview:overlay_view];
//        //[imagePicker.cameraOverlayView bringSubviewToFront:overlay_view];
//        [overlay_view release];
//        
//        [vc presentViewController:imagePicker animated:TRUE completion:nil];
//    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        imagePicker.delegate = self;
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage, nil];
//        imagePicker.allowsEditing = NO;
//        [vc presentViewController:imagePicker animated:TRUE completion:nil];
//    }
//}


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // save original insets
    if( !keyboardShown )
    {
        contentInset = scrollView.contentInset;
        scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
    }
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    int margin = 10;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = activeTextField.frame.origin;
    origin.y -= scrollView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y+activeTextField.frame.size.height-(aRect.size.height) + margin);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
    else {
        scrollView.contentInset = contentInset;
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    }
    
    keyboardShown = true;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    scrollView.contentInset = contentInset;
    scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    keyboardShown = false;
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    activeTextField = textView;
    
    if( textView == food_description && [textView.text isEqualToString:@"Some simple description"] ) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    activeTextField = nil;
    
    if( textView == food_description && [totUtility trimString:food_description.text].length == 0 ) {
        textView.text = @"Some simple description";
        textView.textColor = [UIColor lightGrayColor];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if( btn == publishButton ) {
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/

@end


















