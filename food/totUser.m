//
//  User.m
//  totdev
//
//  Created by Hao Wang on 11/9/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totUser.h"
#import "totEventName.h"
#import "Global.h"
#import "RNEncryptor.h"
#import "totServerCommController.h"
#import "totUtility.h"

@implementation totUser

@synthesize email;

static totModel* _model;

+(void) setModel:(totModel*)model {
    _model = model;
}

// initializer
// init to an existing user
-(id) initWithID:(NSString*)_email {
    if( self = [super init] ) {
        self.email = _email;
    }
    return self;
}

+(BOOL) addAccount:(NSString*)email password:(NSString*)pwd {
    NSString* pwdhash = [self getPasswordHash:pwd salt:nil];
    NSString* account_pref = [NSString stringWithFormat:PREFERENCE_ACCOUNT, email];
    return [_model addPreferenceNoBaby:account_pref value:pwdhash];
}

// add a new user
+(totUser*) newUser:(NSString*)email password:(NSString*)pwd message:(NSString**)message {
    // clean the email
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // register with server
    totServerCommController* server = [[totServerCommController alloc] init];
    int retCode = [server sendRegInfo:@"" withEmail:email withPasscode:pwd returnMessage:message];
    if( retCode == SERVER_RESPONSE_CODE_SUCCESS ) {
        BOOL re = [self addAccount:email password:pwd];
        if( re ) {
            return [[totUser alloc] initWithID:email];
        } else {
            *message = @"Cannot add user to database";
            // TODO should we delete this user from server? otherwise it wouldn't be possible to create the user next time
            return nil;
        }
    } else {
        return nil;
    }
}

+(BOOL)verifyPassword:(NSString*)pwd email:(NSString*)email message:(NSString**)message {
//    NSString* pwdhash_db = @"";
    
//    NSString* account_pref = [NSString stringWithFormat:PREFERENCE_ACCOUNT, email];
//    pwdhash_db = [global.model getPreferenceNoBaby:account_pref];

//    NSData* salt = [self HexString2Data:[pwdhash_db substringToIndex:2*kRNCryptorAES256Settings.keySettings.saltSize]];
//    NSString* pwdhash = [self getPasswordHash:pwd salt:salt];
    
    totServerCommController* server = [[totServerCommController alloc] init];
    int ret = [server sendLoginInfo:email withPasscode:pwd returnMessage:message];
    if( ret == SERVER_RESPONSE_CODE_SUCCESS ) {
        return TRUE;
    } else {
        return FALSE;
    }
}

// request the server to reset password
+(BOOL)forgotPassword:(NSString*)email message:(NSString**)message {
    totServerCommController* server = [[totServerCommController alloc] init];
    int retCode = [server sendForgetPasscodeforUser:email returnMessage:message];
    if( retCode == SERVER_RESPONSE_CODE_SUCCESS ) {
        return TRUE;
    } else
        return FALSE;
}

// change to a new ped
+(BOOL)changePassword:(NSString*)newPasswd oldPassword:(NSString*)oldPassword message:(NSString**)message {
    totServerCommController* server = [[totServerCommController alloc] init];
    int retCode = [server sendResetPasscodeForUser:global.user.email from:oldPassword to:newPasswd returnMessage:message ];
    if( retCode == SERVER_RESPONSE_CODE_SUCCESS ) {
        return TRUE;
    } else {
        return FALSE;
    }
}

// concatenate salt and hash of pwd to the final string, which will be stored
+(NSString*)getPasswordHash:(NSString*)pwd salt:(NSData*)salt {
    // hash the password
    if( salt == nil ) {
        salt = [RNEncryptor randomDataOfLength:kRNCryptorAES256Settings.keySettings.saltSize];
    }
    NSData* data = [RNEncryptor keyForPassword:pwd salt:salt settings:kRNCryptorAES256Settings.keySettings];
    NSString* hash = [self toHexString:data];
    NSString* saltStr = [self toHexString:salt];
    NSString* finalStr = [NSString stringWithFormat:@"%@%@", saltStr, hash];
    return finalStr;
}

+ (NSString*) toHexString:(NSData*)data {
    const unsigned char* bytes = (const unsigned char*)[data bytes];
	NSMutableString* str = [[NSMutableString alloc] initWithCapacity:data.length*2];
	for (unsigned int i = 0; i < data.length; i++) {
		[str appendFormat:@"%02x", bytes[i]];
	}
	return str;
}

+ (NSData*) HexString2Data:(NSString*)str {
	NSMutableData* data = [[NSMutableData alloc] initWithCapacity:str.length/2];
	unsigned char wholeByte;
    char bytes[3] = {'\0','\0','\0'};
    for (unsigned int i = 0; i < str.length/2; i++) {
		bytes[0] = [str characterAtIndex:i*2];
		bytes[1] = [str characterAtIndex:i*2+1];
        wholeByte = strtol(bytes, NULL, 16);
        [data appendBytes:&wholeByte length:1];
	}
	return data;
}


// return total # user accounts in db
+(int) getTotalAccountCount {
    return [_model getAccountCount];
}

// get the user that is logged in last time, this function is used at startup
+(totUser*) getLoggedInUser {
    NSString* email  = [totUtility getSetting:@"email"];
    NSString* secret = [totUtility getSetting:@"secret"];
    NSString* id_str = [totUtility getSetting:@"id_str"];
    NSString* passcode = [totUtility getSetting:@"passcode"];
    
    if( email == nil || secret == nil || id_str == nil || passcode == nil )
        return nil;

    totUser* user = [global.server sendLoginInfo:email withPasscode:passcode returnMessage:nil];
    global.user = user;

    return user;
}

-(void) persistUser {
    [totUtility setSetting:@"email"  value:self.email];
    [totUtility setSetting:@"secret" value:self.secret];
    [totUtility setSetting:@"id_str" value:self.id_str];
    [totUtility setSetting:@"passcode" value:self.passcode];
}

@end
