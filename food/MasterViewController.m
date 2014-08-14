//
//  MasterViewController.m
//  food
//
//  Created by Hao Wang on 6/18/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "FoodItem.h"
#import "FoodItemView.h"
#import "MenuCell.h"
#import "Global.h"
#import "totUtility.h"

@interface MasterViewController () {
    NSMutableArray *objects;
}
@end

@implementation MasterViewController

@synthesize searchBar;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
//    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    [self.tableView setTableHeaderView: v];


    [self refreshData:@"1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshData:(NSString*)location {
    NSLog(@"Loading dishes from %@", location);
    NSArray* data = [global.server getDataForLocation:location secret:global.user.secret];

    if (!objects) {
        objects = [[NSMutableArray alloc] init];
    }
    else
        [objects removeAllObjects];
    
    for (NSDictionary* seller in data) {
        NSDictionary* items = seller[@"items"];
        for (NSDictionary* item in items) {
            NSDictionary* dict = [totUtility JSONToObject:item[@"dish_data"]];
            FoodItem* food = [FoodItem fromDictionary:dict food_id:item[@"dish_id"]];
            
            food.seller_id          = seller[@"seller_id"];
            food.seller_name        = seller[@"seller_name"];
            food.seller_address     = seller[@"seller_address"];
            food.seller_phone       = seller[@"seller_phone"];
            
            [objects addObject:food];
        }
    }
    [self.tableView reloadData];
}

- (void)insertNewObject:(id)sender
{
    if (!objects) {
        objects = [[NSMutableArray alloc] init];
    }
    
    [objects insertObject:[FoodItem getRandomFood] atIndex:0];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell*)[tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];

    FoodItem *f = objects[indexPath.row];
    
    cell.f_name.text = f.food_name;
    cell.f_desc.text = f.food_description;
    [cell.f_price setTitle:[NSString stringWithFormat:@"￥%.0f", f.food_price] forState:UIControlStateNormal];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (IBAction)addToOrder:(UIButton *)sender {
    CGPoint pt = CGPointMake(0, 0);
    pt = [sender convertPoint:pt toView:self.tableView];
    NSIndexPath* path = [self.tableView indexPathForRowAtPoint:pt];
    NSInteger index = path.row;
    [global.order addObject:objects[index]];
    NSLog(@"add item to order. now order size = %lu", global.order.count);
    for (int i=0; i<global.order.count; i++) {
        [(FoodItem*)global.order[i] toString];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)search {
    NSString* location = search.text;
    if( location.length > 0 ) {
        [self refreshData:location];
    }
    [search resignFirstResponder];
}

@end
