//
//  foodTests.m
//  foodTests
//
//  Created by Hao Wang on 6/18/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "totServerCommController.h"
#import "Global.h"

@interface foodTests : XCTestCase {

totServerCommController* server;

}

@end

@implementation foodTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [self printLine];

    server = [[totServerCommController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [self printLine];
}

//- (void)test_0_Register
//{
//    totUser* user = [server sendRegInfo:@"billhao" withEmail:@"billhao@gmail.com" withPasscode:@"111111" returnMessage:nil];
//    global.user = user;
//    NSLog(@"user=%@\nid=%@\nsecret=%@", user.email, user.id_str, user.secret);
//}

- (void)test_1_Login
{
    totUser* user = [server login:@"billhao@gmail.com" withPasscode:@"111111" returnMessage:nil];
    global.user = user;
    NSLog(@"user=%@\nid=%@\nsecret=%@", user.email, user.id_str, user.secret);
}

//- (void)test_3_Publish
//{
//    FoodItem* food = [FoodItem getRandomFood];
//    [server publishItem:food];
//}

- (void)test_2_GetSellerItems
{
    NSArray* items = [server getPublishedItems:global.user.id_str secret:global.user.secret];
    NSLog(@"cnt = %lu", items.count);
}

- (void)test_4_GetItemsAtLocation
{
    NSString* location = @"1";
    NSArray* items = [global.server getDataForLocation:location secret:global.user.secret];
    NSLog(@"cnt = %lu", items.count);
}

- (void)test_5_UploadPhoto {
    UIImage* img = [UIImage imageNamed:@"rou.jpg"];
    NSString* url = [global.server uploadPhoto:img];
    NSLog(@"URL for image is %@", url);
}


- (void)printLine {
    NSLog(@"============================================");
}

@end
