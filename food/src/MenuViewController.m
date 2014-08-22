//
//  MenuViewController.m
//  food
//
//  Created by Hao Wang on 7/22/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "MenuViewController.h"
#import "Global.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sellButtonPressed:(UIButton *)sender {
    
}

- (IBAction)buyButtonPressed:(UIButton *)sender {
    
}

- (IBAction)signoutButtonPressed:(UIButton *)sender {
    [global.user removePersistedUser];
    [self performSegueWithIdentifier:@"goToLoginPage" sender:self];
}

@end
