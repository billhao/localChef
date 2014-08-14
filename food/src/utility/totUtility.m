//
//  totUtility.m
//  totdev
//
//  Created by Yifei Chen on 4/28/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totUtility.h"
#import <QuartzCore/QuartzCore.h>

@implementation totUtility


+(UIImage *)squareCropImage:(UIImage *)origImage{
    UIImage *squareImage;
    
    if(origImage.size.width == origImage.size.height){
        squareImage = origImage;
    }
    else{
        CGRect rect;
        
        if(origImage.size.width > origImage.size.height){
            rect = CGRectMake(round((double)(origImage.size.width-origImage.size.height)/2), 
                              0, 
                              origImage.size.height,
                              origImage.size.height);
            
        }
        else{
            rect = CGRectMake(0,
                              round((double)(origImage.size.height-origImage.size.width)/2), 
                              origImage.size.width,
                              origImage.size.width);
            
        }
        
        CGImageRef subImageRef = CGImageCreateWithImageInRect(origImage.CGImage, rect);  
        UIGraphicsBeginImageContext(rect.size);  
        CGContextRef context = UIGraphicsGetCurrentContext();  
        CGContextDrawImage(context, rect, subImageRef);  
        squareImage = [UIImage imageWithCGImage:subImageRef];  
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);
    }

    return squareImage;    
}


+(NSString *)nowTimeString{
    NSDate *now = [NSDate date];
    return [totUtility dateToString:now];
}

+(NSString *)dateToString:(NSDate*)date{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateString;
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	dateString =[formatter stringFromDate:date];
    return  dateString;
}

+(NSDate *)stringToDate:(NSString*)dateStr{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterFullStyle];
	[formatter setTimeStyle:NSDateFormatterFullStyle];
    NSDate* date = [formatter dateFromString:dateStr];
    return  date;
}

// utility function print a frame
+ (NSString*)getFrameString:(CGRect)frame {
    return [NSString stringWithFormat:@"x=%f y=%f w=%f h=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
}


void print(NSString* str) {

#ifdef DEBUG
    NSLog(@"%@", str);
#endif
    
}


+ (void)enableBorder:(UIView*)v {
    v.layer.borderWidth = 1;
    v.layer.borderColor = [UIColor grayColor].CGColor;
}

+ (CGSize)getScreenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size;
}

+ (CGRect)getWindowRect {
    return [[UIScreen mainScreen] bounds];
    // return CGRectMake(WINDOW_X, WINDOW_Y, WINDOW_W, WINDOW_H);
}

+ (void)showAlert:(NSString*)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// convert a json string to json object
+ (NSArray*)JSONToObject:(NSString*) jsonstring {
    NSError* e = [[NSError alloc] init];
    NSArray* json = [NSJSONSerialization JSONObjectWithData: [jsonstring dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
    return json;
}

+ (NSString*)ObjectToJSON:(id)obj {
    NSError* e = [[NSError alloc] init];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted error:&e];
    
    NSString* jsonstr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonstr;
}


+ (AppDelegate*)getAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

// crop image
+ (UIImage *)crop:(UIImage*)image rect:(CGRect)rect {
    float scale = image.scale;
    rect = CGRectMake(rect.origin.x * scale,
                      rect.origin.y * scale,
                      rect.size.width * scale,
                      rect.size.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}


+ (NSString *)imageToString:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
+ (UIImage *)stringToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+ (NSString*)saveImage:(UIImage*)image filename:(NSString*)filename {
    NSData* imageData = UIImagePNGRepresentation(image);
    return [totUtility saveImageData:imageData filename:filename];
}

+ (NSString*)saveImageData:(NSData*)imageData filename:(NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:filename];
    
    if (![imageData writeToFile:imagePath atomically:NO]){
        NSLog((@"Failed to cache image data to disk"));
    }
    else{
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
    return imagePath;
}

@end
