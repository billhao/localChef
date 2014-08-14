//
//  totServerCommController.m
//  tot_server
//
//  Created by LZ on 13-9-21.
//  Copyright (c) 2013年 tot. All rights reserved.
//

#import "totServerCommController.h"
#import "Base64Encoder.h"
#import "totUtility.h"
#import "FoodItem.h"
#import "Global.h"

// class extention for private method declaration
@interface totServerCommController()

- (id) sendStr: (NSString*) post toURL: (NSString *) dest_url returnMessage: (NSString**)message;
- (void) sendStrAsync:(NSString*)post toURL:(NSString *)dest_url returnMessage:(NSString**)message
             callback:(totURLConnectionCallback)callback;

@end

@implementation totServerCommController

// -----------------------------------------------
//  constructor
//    -> setup parameters to connect to server
// -----------------------------------------------
- (id) init {
    self = [super init];
    if (self) {
        m_reg_url            = [NSString stringWithFormat:@"%@/login",    HOSTNAME];
        m_login_url          = [NSString stringWithFormat:@"%@/login",    HOSTNAME];
        m_changePasscode_url = [NSString stringWithFormat:@"%@/m/reset",  HOSTNAME];
        m_forgetPasscode_url = [NSString stringWithFormat:@"%@/m/forget", HOSTNAME];
        m_sendUsrAct_url     = [NSString stringWithFormat:@"%@/m/usract", HOSTNAME];

        m_data_url           = [NSString stringWithFormat:@"%@/data",     HOSTNAME];
    }
    return self;
}

// -----------------------------------------------
//  sendRegInfo
//    -> usrname: baby's name
//    -> call sendUsrName to send the usr reg info
//       to reg handler on server side
// -----------------------------------------------
- (totUser*) sendRegInfo: (NSString*) usrname withEmail: (NSString*) email withPasscode: (NSString*) passcode returnMessage:(NSString**)message
{
    NSString* data = [NSString stringWithFormat:@"type=register&usr=%@&pwd=%@", email, passcode];
    NSDictionary* resp = (NSDictionary*)[self sendStr:data toURL:m_reg_url returnMessage:message];
    
    if( resp[@"status"] != nil ) {
        long status = [resp[@"status"] intValue];
        if( status == 0 )
            return 0;
    }
    totUser* user = [[totUser alloc] init];
    user.email = resp[@"username"];
    user.secret = resp[@"secret"];
    user.id_str = resp[@"id"];
    return user;
}

// -----------------------------------------------
//  sendLoginInfo
//    -> call sendUsrName to send the usr login
//       info to login handler on server side
// -----------------------------------------------
- (totUser*) sendLoginInfo: (NSString*) email withPasscode: (NSString*) passcode returnMessage:(NSString**)message {
    NSString* data = [NSString stringWithFormat:@"type=login&usr=%@&pwd=%@", email, passcode];
    NSDictionary* resp = [self sendStr:data toURL:m_login_url returnMessage:message];

    if( resp[@"status"] != nil ) {
        long status = [resp[@"status"] intValue];
        if( status == 0 )
            return 0;
    }
    totUser* user = [[totUser alloc] init];
    user.email = resp[@"username"];
    user.secret = resp[@"secret"];
    user.id_str = resp[@"id"];
    
    return user;
}

// -----------------------------------------------
//  change passcode
// -----------------------------------------------
- (int) sendResetPasscodeForUser: (NSString*) email
                                   from: (NSString*) old_passcode
                                     to: (NSString*) new_passcode
                          returnMessage: (NSString**)message
{
    NSString* loginInfo = @"email=";
    loginInfo = [loginInfo stringByAppendingString:email];
    loginInfo = [loginInfo stringByAppendingString:@"&oldpasscode="];
    loginInfo = [loginInfo stringByAppendingString:old_passcode];
    loginInfo = [loginInfo stringByAppendingString:@"&newpasscode="];
    loginInfo = [loginInfo stringByAppendingString:new_passcode];
    return [self sendStr:loginInfo toURL:m_changePasscode_url returnMessage:message];
}

// -----------------------------------------------
//   send forget passcode request to server
// -----------------------------------------------
- (int) sendForgetPasscodeforUser: (NSString*) email returnMessage:(NSString**)message {
    NSString* loginInfo = [NSString stringWithFormat:@"email=%@",email];
    return [self sendStr:loginInfo toURL:m_forgetPasscode_url returnMessage:message];
}

// -----------------------------------------------
//   send user activity to server
// -----------------------------------------------
- (void) sendUserActivityToServer: (NSString*) email withActivity: (NSString*) activity returnMessage:(NSString**)message callback:(void(^)(int ret, NSString* msg))callback {
    NSString* actInfo = @"email=";
    actInfo = [actInfo stringByAppendingString:email];
    actInfo = [actInfo stringByAppendingString:@"&act="];
    actInfo = [actInfo stringByAppendingString:activity];
    [self sendStrAsync:actInfo toURL:m_sendUsrAct_url returnMessage:message callback:callback];
}


// -----------------------------------------------
//  basic func to send POST req to server
//    -> remember to check whether the return is nil
//  returns NSDictionary or NSArray
// -----------------------------------------------
- (id) sendStr: (NSString*) post toURL: (NSString *) dest_url returnMessage: (NSString**)message {
    NSLog(@"post string: %@", post);
    
    // TODO add try catch here
    NSMutableURLRequest* request = [self getRequest:post toURL:dest_url];

    // Send the req syncrhonously [will be async later]
    //NSURLResponse *response;
    
    totURLConnection* conn = [[totURLConnection alloc] initWithRequest:request
                                                              delegate:self
                                                      startImmediately:YES
                                                              callback:^(int ret, NSString *msg) {}];

    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    while( !conn.finished ) {
        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    NSData* data = conn.responseData;
    NSString *strReply = [[NSString alloc] initWithBytes:[data bytes]
                                                  length:[data length]
                                                encoding:NSASCIIStringEncoding];
    // Debug printout
    if (strReply == nil) {
        NSLog(@"post response: empty");
        return nil;
    } else {
        NSLog(@"post response: %@", strReply);
    }

    // parse the response
    id resp = [totUtility JSONToObject:strReply];
    return resp;
}

- (void) sendStrAsync:(NSString*)post toURL:(NSString *)dest_url returnMessage:(NSString**)message
             callback:(totURLConnectionCallback)callback {
    // TODO add try catch here
    NSMutableURLRequest* request = [self getRequest:post toURL:dest_url];
    totURLConnection* conn = [[totURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES callback:callback];
}

- (NSMutableURLRequest*)getRequest:(NSString*)post toURL: (NSString *)dest_url {
    // Construct a HTTP POST req
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLen = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:dest_url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLen forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setCachePolicy:NSURLCacheStorageNotAllowed];
    [request setTimeoutInterval:20.0];

    // ignore SSL certificate error
    NSURL* destURL = [NSURL URLWithString:dest_url];
    
    // add HTTP basic authentication header to the request
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"totdev", @"0000"];
    NSData *authStrData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authStrDataEncoded = [Base64Encoder encode:authStrData];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", authStrDataEncoded];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    return request;
}

#pragma mark - NSURLConnection delegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSString* s = challenge.protectionSpace.host;
        if ([challenge.protectionSpace.host isEqualToString:HOSTNAME_SHORT]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    totURLConnection* conn = (totURLConnection*)connection;
    conn.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    totURLConnection* conn = (totURLConnection*)connection;
    [conn.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    totURLConnection* conn = (totURLConnection*)connection;
    NSData* data = conn.responseData;
    NSString *strReply = [[NSString alloc] initWithBytes:[data bytes]
                                                  length:[data length]
                                                encoding:NSASCIIStringEncoding];
    // Debug printout
    if (strReply == nil) {
        NSLog(@"post response: empty");
    } else {
        // NSLog(@"post response: %@", strReply);
    }
    int ret = SERVER_RESPONSE_CODE_FAIL;
    NSArray* ss = [strReply componentsSeparatedByString:@"::"];
    
    NSString* message = nil;
    if( ss.count >= 1 && ss.count <= 2 ) {
        ret = [(NSString*)ss[0] intValue];
        if( ss.count == 2 ) {
            message = (NSString*)ss[1];
        }
    } else
        message = @"Cannot understand server's response";
    
    conn.callback(ret, message);
    conn.finished = TRUE;
}





//======================================================================================================
// for buyer
//======================================================================================================
- (NSArray*)getDataForLocation:(NSString*)location secret:(NSString*)secret {
    NSString* req = [NSString stringWithFormat:@"type=listdishregion&secret=%@&region=%@", secret, location];
    id resp = [self sendStr:req toURL:m_data_url returnMessage:nil];
    
    if( [resp isKindOfClass:[NSDictionary class]]) {
        if( resp[@"status"] != nil ) {
            long status = [resp[@"status"] intValue];
            if( status == 0 )
                return 0;
        }
        if( resp[@"login"] != nil ) {
            long login = [resp[@"login"] intValue];
            if( login == 0 )
                return 0;
        }
    }
    
    // success
    return (NSArray*) resp;
}

- (int)submitOrder:(int)food_id quantity:(int)quantity buyer_id:(int)user_id {
    return 0;
}


//======================================================================================================
// for seller
//======================================================================================================
- (NSString*)publishItem:(FoodItem*)food {
    NSLog(@"Publishing food item %@ to server", food.food_name);

    NSDictionary* req = [FoodItem toDictionary:food];
    NSString* reqStr = [totUtility ObjectToJSON:req];
    NSString* data = [NSString stringWithFormat:@"type=dish&data=%@&secret=%@", reqStr, global.user.secret];
    NSDictionary* resp = [self sendStr:data toURL:m_data_url returnMessage:nil];
    
    if( resp[@"status"] == nil )
        return 0;
    
    long status = [resp[@"status"] intValue];
    if( status == 0 )
        return 0;

    return @"100";
}

- (NSArray*)getPublishedItems:(NSString*)seller_id secret:(NSString*)secret {
    NSString* req = [NSString stringWithFormat:@"type=listdish&secret=%@&seller=%@", secret, seller_id];
    id resp = [self sendStr:req toURL:m_data_url returnMessage:nil];
    
    if( [resp isKindOfClass:[NSDictionary class]]) {
        if( resp[@"status"] != nil ) {
            long status = [resp[@"status"] intValue];
            if( status == 0 )
                return 0;
        }
        if( resp[@"login"] != nil ) {
            long login = [resp[@"login"] intValue];
            if( login == 0 )
                return 0;
        }
    }
    
    // success
    return (NSArray*) resp;
}

@end





