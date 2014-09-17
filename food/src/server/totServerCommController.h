//
//  totServerCommController.h
//  tot_server
//
//  Created by LZ on 13-9-21.
//  Copyright (c) 2013年 tot. All rights reserved.
//

/* For reference
 
 response_code = {  'login_success': 0, 'login_unmatch': 1, 'login_no_usr': 2,
                    'reg_success': 10, 'reg_usr_exist': 11,
                    'reset_success': 20, 'reset_old_pc_wrong': 21, 'reset_no_usr': 22,
                    'retrieve_link_snd': 30, 'retrieve_fail': 31
                    }
 */

#import <Foundation/Foundation.h>
#import "totURLConnection.h"
#import "FoodItem.h"
#import "Order.h"
#import "totUser.h"

#define HOSTNAME @"http://server.localchefapp.com"
#define HOSTNAME_SHORT @"server.localchefapp.com"

// photo related constants
#define BOUNDARY @"0xKhTmLbOuNdArY"

enum SERVER_RESPONSE_CODE {
    SERVER_RESPONSE_CODE_FAIL = -1,
    SERVER_RESPONSE_CODE_SUCCESS = 0,
    SERVER_RESPONSE_CODE_REG_USER_EXIST = 1,
};

@interface totServerCommController : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSString *m_reg_url;  // url to the registration handler
    NSString *m_login_url; // url to the login handler
    NSString *m_changePasscode_url;  // url to the change passcode handler
    NSString *m_forgetPasscode_url;  // url to the forget passcode handler
    NSString *m_sendUsrAct_url;  // usl to the user activity handler

    NSString *m_data_url;
    NSString *m_order_url;
    NSString *m_photo_url;
    NSString *m_notification_url;
}

#pragma mark - common
- (totUser*)registerUser:(NSString*)username phone:(NSString*)phone passcode:(NSString*)passcode returnMessage:(NSString**)message;
- (totUser*)login: (NSString*)phone withPasscode:(NSString*)passcode returnMessage:(NSString**)message;
- (BOOL)updateDeviceToken:(NSString*)devToken;
- (NSMutableArray*)listOrderForSeller;
- (NSArray*)listOrderForBuyer;


#pragma mark - for buyer
- (NSArray*)getDataForLocation:(NSString*)location secret:(NSString*)secret;
- (NSString*)addOrder:(NSString*)dish_id;
- (BOOL)deleteOrder:(NSString*)order_id;


#pragma mark - for seller
- (NSString*)publishItem:(FoodItem*)food_item;
- (NSArray*)getPublishedItems:(NSString*)seller_id secret:(NSString*)secret;
- (BOOL)updateOrder:(Order*)order; // for seller confirmation
- (NSString*)uploadPhoto:(UIImage*)img imageFilename:(NSString*)imageFilename;
- (UIImage*)downloadPhoto:(NSString*)imageFilename;
- (NSURL*)getImageURL:(NSString*)imageURLString;

#pragma mark - old ones from tot
- (int) sendResetPasscodeForUser: (NSString*) email from: (NSString*) old_passcode to: (NSString*) new_passcode returnMessage: (NSString**)message;
- (int) sendForgetPasscodeforUser: (NSString*) email returnMessage:(NSString**)message;
- (void) sendUserActivityToServer: (NSString*) email withActivity: (NSString*) activity returnMessage:(NSString**)message
                         callback:(void(^)(int ret, NSString* msg))callback;


@end
