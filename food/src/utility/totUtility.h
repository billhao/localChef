//
//  totUtility.h
//  totdev
//
//  Created by Yifei Chen on 4/28/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface totUtility : NSObject


+(UIImage *)squareCropImage:(UIImage *)origImage;  

////////////////////////////////////////////////////
// date functions
+(NSString *)nowTimeString;

+(NSString *)dateToString:(NSDate*)date;
+(NSDate *)stringToDate:(NSString*)dateStr;

+(NSString *)dateToStringShort:(NSDate*)date;
+(NSDate *)stringToDateShort:(NSString*)dateStr;

+(NSString *)dateToStringFull:(NSDate*)date;
+(NSDate *)stringToDateFull:(NSString*)dateStr;

+(NSString *)dateToStringHumanReadable:(NSDate*)date;
////////////////////////////////////////////////////

// utility function print a frame
+ (NSString*)getFrameString:(CGRect)frame;

+ (NSString*)trimString:(NSString*)str;

+ (void)enableBorder:(UIView*)v;

+ (CGSize)getScreenSize;
+ (CGRect)getWindowRect;

+ (void)showAlert:(NSString*)text;
+ (void)showConfirmation:(NSString*)text delegate:(id<UIAlertViewDelegate>)delegate;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

// json string to object
+ (NSArray*)JSONToObject:(NSString*) jsonstring;
// object to json string
+ (NSString*)ObjectToJSON:(id)obj;

+ (AppDelegate*)getAppDelegate;

// crop image
+ (UIImage *)crop:(UIImage*)image rect:(CGRect)rect;

// encode and decode image to/from string
+ (NSString *)imageToString:(UIImage *)image;
+ (UIImage *)stringToImage:(NSString *)strEncodeData;

// save image to disk
+ (NSString*)saveImage:(UIImage*)image filename:(NSString*)filename;
+ (NSString*)saveImageData:(NSData*)imageData filename:(NSString*)filename;

// get/set settings
+ (void)setSetting:(NSString*)key value:(NSString*)value;
+ (NSString*)getSetting:(NSString*)key;
+ (void)removeSetting:(NSString*)key;
+ (void)resetSettings;


+ (NSString *) GetDocumentDirectory;
+ (void)createImageCacheDirectory;


+ (NSString *) md5:(NSString *) input;

@end

extern void print(NSString* str);