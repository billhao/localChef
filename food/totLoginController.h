//
//  totLoginController.h
//  totdev
//
//  Created by Hao on 5/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "totModel.h"
#import "totUser.h"

@class AppDelegate;

@interface totLoginController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *mPhone, *mPwd, *mCurrentControl;
    IBOutlet UIButton*    mLogin;
    IBOutlet UIButton*    mNewuser;
    IBOutlet UIButton*    mPrivacy;
    IBOutlet UIButton*    mForgotPwd;

    totModel* model;
}

// create new user or login
@property (nonatomic) BOOL newuser; // whether shown as create new user page or login page, this is set before current view is shown

- (IBAction) backgroundTap:(id) sender;

- (BOOL)checkEmail;
+ (BOOL)checkPwd:(NSString*)pwd;

- (void)setLoggedIn:(totUser*)user;
- (void)showHomeView;

- (void)showAlert:(NSString*)text; // show a message box

- (AppDelegate*) getAppDelegate;

@end
