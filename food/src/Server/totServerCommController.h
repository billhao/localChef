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
#import "totUser.h"

#define HOSTNAME @"http://54.187.194.66"
#define HOSTNAME_SHORT @"54.187.194.66"

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
}

- (totUser*) sendRegInfo: (NSString*) usrname withEmail: (NSString*) email withPasscode: (NSString*) passcode returnMessage:(NSString**)message;
- (totUser*) sendLoginInfo: (NSString*) email withPasscode: (NSString*) passcode returnMessage:(NSString**)message;
- (int) sendResetPasscodeForUser: (NSString*) email from: (NSString*) old_passcode to: (NSString*) new_passcode returnMessage: (NSString**)message;
- (int) sendForgetPasscodeforUser: (NSString*) email returnMessage:(NSString**)message;
- (void) sendUserActivityToServer: (NSString*) email withActivity: (NSString*) activity returnMessage:(NSString**)message
                        callback:(void(^)(int ret, NSString* msg))callback;

// common
//- (totUser*)register:(NSString*)username passwd:(NSString*)passwd;
//- (totUser*)login:(NSString*)username passwd:(NSString*)passwd;

// for buyer
- (NSMutableArray*)getDataForLocation:(int)location;
- (int)submitOrder:(int)food_id quantity:(int)quantity buyer_id:(int)user_id;

// for seller
- (NSString*)publishItem:(FoodItem*)food_item;
- (NSArray*)getPublishedItems:(NSString*)seller_id secret:(NSString*)secret;

@end
