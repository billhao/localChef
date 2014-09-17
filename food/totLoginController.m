//
//  totLoginController.m
//  totdev
//
//  Created by Hao on 5/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totLoginController.h"
#import "AppDelegate.h"
#import "totEventName.h"
#import "totUtility.h"
#import "Global.h"

@implementation totLoginController

@synthesize newuser;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        newuser = FALSE;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    // set up events
    [mLogin addTarget:self action:@selector(LoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mNewuser addTarget:self action:@selector(NewUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [mPhone setDelegate:self];
    [mPwd setDelegate:self];
    
//    NSString* email_string = @"Email";
//    if (![email_string isEqualToString:NSLocalizedString(@"Email", @"")]) {
//        UIButton* login_button = [UIButton buttonWithType:UIButtonTypeCustom];
//        login_button.layer.cornerRadius = 5;
//        [login_button setFrame:mLogin.frame];
//        [login_button setTitle:NSLocalizedString(@"Login", @"") forState:UIControlStateNormal];
//        [login_button setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0]
//                           forState:UIControlStateNormal];
//        [login_button setBackgroundColor:[UIColor colorWithRed:51/255.0f green:209/255.0 blue:33/255.0 alpha:1.0f]];
//        [login_button addTarget:self
//                         action:@selector(LoginButtonClicked:)
//               forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:login_button];
//        
//        UIButton* register_button = [UIButton buttonWithType:UIButtonTypeCustom];
//        register_button.layer.cornerRadius = 5;
//        [register_button setFrame:mNewuser.frame];
//        [register_button setTitle:NSLocalizedString(@"Register", @"") forState:UIControlStateNormal];
//        [register_button setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0]
//                              forState:UIControlStateNormal];
//        [register_button setBackgroundColor:[UIColor colorWithRed:245/255.0f green:73/255.0 blue:82/255.0 alpha:1.0f]];
//        [register_button addTarget:self
//                            action:@selector(NewUserButtonClicked:)
//                  forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:register_button];
//    }
    //mLogin.hidden = true;
    //mNewuser.hidden = true;
}

-(void)viewDidAppear:(BOOL)animated {
    totUser* user = [totUser getLoggedInUser];
    if( user != nil ) {
        global.user = user;
        [self showHomeView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    return;
    
    UIImage* bgImg;
    if( newuser ) {
        //mLogin.hidden = TRUE;
        //mNewuser.frame = CGRectMake(47, mNewuser.frame.origin.y, mNewuser.frame.size.width, mNewuser.frame.size.height);
        
        //set background
        bgImg = [UIImage imageNamed:@"bg_registration"];
//        UIColor* bg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_registration"]];
//        self.view.backgroundColor = bg;
//        [bg release];
    }
    else {
       // mNewuser.hidden = FALSE;
        
        //set background
        bgImg = [UIImage imageNamed:@"bg_login"];
//        UIColor* bg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_login"]];
//        self.view.backgroundColor = bg;
//        [bg release];
    }
//    self.view.backgroundColor = [UIColor blackColor];
//    UIImageView* bgImgView = [[UIImageView alloc] initWithImage:bgImg];
//    [self.view addSubview:bgImgView];
//    [self.view sendSubviewToBack:bgImgView];

    // set email and clear password
//    NSString* lastlogin = [model getPreferenceNoBaby:PREFERENCE_LAST_LOGGED_IN];
//    if( lastlogin==nil )
//        mEmail.text = @"";
//    else {
//        mEmail.text = lastlogin;
//    }
//    mPwd.text = @"";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)LoginButtonClicked: (UIButton *)button {
    [self backgroundTap:nil]; // dismiss keyboard

    // check if email and pwd matches db
    NSString* phone = mPhone.text;
    NSString* pwd = mPwd.text;
    
    // check validity of email and pwd
    if( ![self checkEmail] ) return;
    if( ![totLoginController checkPwd:pwd] ) return;
    
    totUser* user = [global.server login:phone withPasscode:pwd returnMessage:nil];
    if( user == nil )
        [self showAlert:@"Phone number and passcode do not match"];
    else {
        user.passcode = pwd;
        global.user = user;
        [self setLoggedIn:user];
        [self showHomeView];
    }
}

- (void)NewUserButtonClicked: (UIButton *)button {
    NSString* name = mName.text;
    NSString* phone = mPhone.text;
    NSString* pwd = mPwd.text;
    
    // check validity of email and pwd
    if( ![self checkName] ) return;
    if( ![self checkEmail] ) return;
    if( ![totLoginController checkPwd:pwd] ) return;
    
    totUser* user = [global.server registerUser:name phone:phone passcode:pwd returnMessage:nil];
    if( user == nil )
        [self showAlert:@"This phone number has already signed up"];
    else {
        user.passcode = pwd;
        global.user = user;
        [self setLoggedIn:user];
        [self showHomeView];
    }
}

- (void)ForgotPwdButtonClicked: (UIButton *)button {
    if( ![self checkEmail] ) return;

    NSString* email = mPhone.text;
    NSString* msg = nil;
    BOOL re = [totUser forgotPassword:email message:&msg];
    if( msg )
        [self showAlert:msg];
    else
        [self showAlert:@"Cannot reset password"];
}

- (void)showAlert:(NSString*)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                    message:text 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

// set the logged in flag in db
- (void)setLoggedIn:(totUser*)user {
    [user persistUser];
}

- (void)showHomeView {
    [[totUtility getAppDelegate] initNotification];
    [self performSegueWithIdentifier:@"nextPageSegue" sender:self];
}

- (void)PrivacyButtonClicked: (UIButton *)button {
}

// check phone against a regex
- (BOOL)checkEmail {
    NSString* email = mPhone.text;
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if( email.length == 0 ) {
        [self showAlert:@"Please type in your phone number"];
        return FALSE;
    }
    
    // check
//    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *emailRegEx = @"[0-9._-]{10,12}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:email] == NO) {
        [self showAlert:@"Phone number must be 9 digits"];
        return FALSE;
    }
    
    return TRUE;
}

// check email against a regex
- (BOOL)checkName {
    NSString* name = mName.text;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if( name.length == 0 ) {
        [self showAlert:@"Please type in your name"];
        return FALSE;
    }
    
    // check
    //    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *nameRegEx = @"[\\w\\s]{2,20}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegEx];
    
    if ([nameTest evaluateWithObject:name] == NO) {
        [self showAlert:@"Please check the name"];
        return FALSE;
    }
    
    return TRUE;
}

// password needs to be 4 chars or more
+ (BOOL)checkPwd:(NSString*)pwd {
    NSString* pwd1 = [pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if( pwd.length != pwd1.length ) {
        [totUtility showAlert:@"Password cannot start or end with space"];
        return FALSE;
    }
    else if( pwd.length < 4 ) {
        // prompt for a valid pwd
        [totUtility showAlert:@"Password must be at least 4 characters"];
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    mCurrentControl = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    mCurrentControl = nil;
}

// dismiss the keyboard when tapping on background
- (IBAction) backgroundTap:(id) sender{
    if( mCurrentControl == mPhone ) {
        [mPhone resignFirstResponder];
    }
    else if( mCurrentControl == mPwd ) {
        [mPwd resignFirstResponder];
    }
}

-(AppDelegate*) getAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

@end
