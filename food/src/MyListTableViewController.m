//
//  MyListTableViewController.m
//  food
//
//  Created by Hao Wang on 7/31/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "MyListTableViewController.h"
#import "PublishViewController.h"

#import "FoodItem.h"
#import "FoodItemView.h"
#import "SellerOrderCell.h"
#import "Global.h"
#import "totUtility.h"
#import "SellerSectionHeaderCell.h"
#import "UIImageView+WebCache.h"

@interface MyListTableViewController ()

@end

@implementation MyListTableViewController {
    NSMutableArray *foodItems;
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

-(void)viewWillAppear:(BOOL)animated {
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshData {
    foodItems = [global.server listOrderForSeller];
}

- (void)insertNewObject:(id)sender
{
    if (!foodItems) {
        foodItems = [[NSMutableArray alloc] init];
    }
    
    [foodItems insertObject:[FoodItem getRandomFood] atIndex:0];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return foodItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    FoodItem* food = foodItems[section];
    if( food == nil || food.orders == nil )
        return 0;
    else
        return food.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@", indexPath);
    
    SellerOrderCell *cell = (SellerOrderCell*)[tableView dequeueReusableCellWithIdentifier:@"SellerOrderCell" forIndexPath:indexPath];
    
    FoodItem* food = foodItems[indexPath.section];
    Order* order = food.orders[indexPath.row];
//    Order* order = [[Order alloc] init];
//    order.order_id = @"d0030cf6c33f0624b9a59a713b15d086";
//    order.order_status = ORDER_STATUS_CONFIRMED;
    cell.order = order;
    
    if( [order.order_status isEqualToString:ORDER_STATUS_ORDERED] ) {
        cell.confirmButton.hidden = false;
        cell.confirmedButton.hidden = true;
    }
    else {
        cell.confirmButton.hidden = true;
        cell.confirmedButton.hidden = false;
    }
    cell.f_name.text = [NSString stringWithFormat:@"Ordered on %@\nBy %@\n%@\n%@", [totUtility dateToStringHumanReadable:order.created_at], order.buyer.name, order.buyer.phone, order.buyer.address];

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
        [foodItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SellerSectionHeaderCell *cell = (SellerSectionHeaderCell*)[tableView dequeueReusableCellWithIdentifier:@"SellerSectionHeaderCell"];
    
    FoodItem* f = foodItems[section];
    
    cell.food_name.text = [NSString stringWithFormat:@"$ %.0f %@\nQuantity: %ld\nAvailable between\n%@ - %@\n%@", f.food_price, f.food_name, f.food_quantity, [totUtility dateToStringHumanReadable:f.food_start_time], [totUtility dateToStringHumanReadable:f.food_end_time], f.food_description];

    UIImage* placeHolderImage = [UIImage imageNamed:@"fish.jpg"];
    if( f.food_image_url && f.food_image_url.length > 0 ) {
        //UIImage* img = [global.server downloadPhoto:f.food_image_url];
        //cell.food_image.image = img;
        [cell.food_image sd_setImageWithURL:[global.server getImageURL:f.food_image_url] placeholderImage:[UIImage imageNamed:@"fish.jpg"]];
    }
    else
        cell.food_image.image = placeHolderImage;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SellerSectionHeaderCell *cell = (SellerSectionHeaderCell*)[tableView dequeueReusableCellWithIdentifier:@"SellerSectionHeaderCell"];
    return cell.frame.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114;
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
        NSDate *object = foodItems[indexPath.row];
        //self.detailViewController.detailItem = object;
    }
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

- (IBAction)goToMyList:(UIStoryboardSegue *)segue {
    PublishViewController* publishVC = (PublishViewController*)[segue sourceViewController];
}

- (IBAction)confirmOrder:(UIButton*)sender {
    int i = 5;
    UIView* v = sender.superview;
    while( i > 0 ) {
        if( [v isKindOfClass:[SellerOrderCell class]] )
            break;
        v = v.superview;
        i--;
    }
    if( i == 0 ) {
        NSLog(@"Cannot find SellerOrderCell of the confirm button");
        return;
    }
    
    // handle the confirm button
    SellerOrderCell* cell = (SellerOrderCell*)v;
    Order* order = cell.order;
    NSLog(@"%@", order.order_id);
    order.order_status = ORDER_STATUS_CONFIRMED;
    [global.server updateOrder:order];
    
    // reload the data from server
    [self refreshData];
    [self.tableView reloadData];
}

@end
