/*
 * Represents a user and all operations
 */


#import <Foundation/Foundation.h>
#import "totModel.h"


@interface totUser : NSObject {
    NSString* email;
}

@property(nonatomic,retain) NSString* email;
@property(nonatomic,retain) NSString* phone;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* address;
@property(nonatomic,retain) NSString* location; // zip code
@property(nonatomic,retain) NSString* secret;
@property(nonatomic,retain) NSString* id_str;
@property(nonatomic,retain) NSString* passcode;

// initializer
-(id) initWithID:(NSString*)_email;    // init to an existing user
-(id) initWithDict:(NSDictionary*)dict;

-(void) persistUser;
-(void) removePersistedUser;

+(void) setModel:(totModel*)model;

// add a new user
//+(totUser*) newUser:(NSString*)email password:(NSString*)pwd message:(NSString**)message;

// add a user to db
+(BOOL) addAccount:(NSString*)email password:(NSString*)pwd;

+(BOOL)verifyPassword:(NSString*)pwd email:(NSString*)email message:(NSString**)message;

// request the server to reset password
+(BOOL)forgotPassword:(NSString*)email message:(NSString**)message;

// change to a new ped
+(BOOL)changePassword:(NSString*)newPasswd oldPassword:(NSString*)oldPassword message:(NSString**)message;

// return total # user accounts in db
+(int) getTotalAccountCount;

// get the user that is logged in last time, this function is used at startup
+(totUser*) getLoggedInUser;


@end
