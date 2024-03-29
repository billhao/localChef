//
//  OrderViewController.m
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "OrderListViewController.h"
#import "FoodItem.h"
#import "Global.h"
#import "OrderCell.h"
#import "UIImageView+WebCache.h"

@interface OrderListViewController ()
@end

@implementation OrderListViewController

@synthesize totalLabel;

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
//    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
//    self.navigationItem.leftBarButtonItem = done;

    orders = [[NSMutableArray alloc] init];
    
    noItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 160)];
    noItemLabel.lineBreakMode = NSLineBreakByWordWrapping;
    noItemLabel.numberOfLines = 0;
    noItemLabel.font = [UIFont fontWithName:@"Helvetica Neue Thin" size:20];
    noItemLabel.textColor = [UIColor grayColor];
    noItemLabel.textAlignment = NSTextAlignmentCenter;
    noItemLabel.hidden = true;
    [self.view insertSubview:noItemLabel aboveSubview:self.tableView];

    // init activity indicator
    //activityIndicator = [[ActivityIndicatorView alloc] init];
    //[self.view addSubview:activityIndicator.view];

    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.alpha = 0.4;
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(loadOrders) forControlEvents:UIControlEventValueChanged];

//    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 80, 0);
//    self.tableView.contentInset = inset;
//    self.tableView.scrollIndicatorInsets = inset;
//
//    CGRect frame = self.view.bounds;
//    frame.origin.y = frame.size.height - 80;
//    frame.size.height = 80;
//    UIView* totalView = [[UIView alloc] initWithFrame:frame];
//    totalView.backgroundColor = [UIColor grayColor];
//    [self.view.superview.superview addSubview:totalView];
//    [self.view.superview.superview bringSubviewToFront:totalView];
}

-(void)viewDidAppear:(BOOL)animated {
    [self loadOrders];
}

- (void)doneButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    
//    [_objects insertObject:[FoodItem getRandomFood] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell = (OrderCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    
    //NSLog(@"%ld", indexPath.row);
    Order* order = orders[indexPath.row];
    FoodItem* f = order.food;

    NSString* status;
    if( [order.order_status isEqualToString:ORDER_STATUS_ORDERED] )
        status = [NSString stringWithFormat:@"Waiting for %@'s confirmation", order.seller.name];
    else if( [order.order_status isEqualToString:ORDER_STATUS_CONFIRMED] )
        status = @"Confirmed";
    else if( [order.order_status isEqualToString:ORDER_STATUS_COMPLETED] )
        status = @"Completed";
    else
        status = @"Status Unknown";
    cell.f_time_status.text = [NSString stringWithFormat:@"  Ordered on %@\n  %@", [totUtility dateToStringHumanReadable:order.created_at], status];
    cell.f_name.text = [NSString stringWithFormat:@"$ %.0f %@\nBy %@\n%@\n%@\n%@", f.food_price, f.food_name, order.seller.name, order.seller.address, order.seller.phone,
                        [NSString stringWithFormat:@"Available %@ - %@", [totUtility dateToStringHumanReadable:f.food_start_time], [totUtility dateToStringHumanReadable:f.food_end_time]]];
    cell.f_start_end_time.text = [NSString stringWithFormat:@"Available %@ - %@", [totUtility dateToStringHumanReadable:f.food_start_time], [totUtility dateToStringHumanReadable:f.food_end_time]];
//    [cell.f_name sizeToFit];
    
    UIImage* placeHolderImage = [UIImage imageNamed:@"place_holder_buyer_list_page"];
    if( f.food_image_url && f.food_image_url.length > 0 ) {
//        UIImage* img = [global.server downloadPhoto:f.food_image_url];
//        cell.f_image.image = img;
        [cell.f_image sd_setImageWithURL:[global.server getImageURL:f.food_image_url] placeholderImage:placeHolderImage];
    }
    else
        cell.f_image.image = placeHolderImage;
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 280;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)payButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.alipay.com"]];
}

- (IBAction)removeButtonPressed:(UIButton *)sender {
    CGPoint pt = CGPointMake(0, 0);
    pt = [sender convertPoint:pt toView:self.tableView];
    NSIndexPath* path = [self.tableView indexPathForRowAtPoint:pt];
    NSInteger index = path.row;
    Order* order = orders[index];
    
    [self.tableView beginUpdates];
    [orders removeObjectAtIndex:index];
    NSMutableArray* del = [[NSMutableArray alloc] initWithObjects:path, nil];
    [self.tableView deleteRowsAtIndexPaths:del withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    // delete and reload on server
    [global.server deleteOrder:order.order_id];
    [self loadOrders];
}

- (void)loadOrders {
    //[activityIndicator start];
    
    if( !self.refreshControl.refreshing) {
        [self.refreshControl beginRefreshing];
        int h = self.refreshControl.frame.size.height;
        int hh = self.tableView.contentOffset.y;
        [self.tableView setContentOffset:CGPointMake(0, hh-h) animated:NO];
    }
    
    orders = [[NSMutableArray alloc] initWithArray:[global.server listOrderForBuyer]];
    
    if( orders.count == 0 ) {
        noItemLabel.text = @"You have not placed an order. Try order something from a neighbor";
        noItemLabel.hidden = false;
    }
    else
        noItemLabel.hidden = true;

    //[activityIndicator stop];
    
    if( self.refreshControl.refreshing)
        [self.refreshControl endRefreshing];
    
    [self.tableView reloadData];
}

@end







