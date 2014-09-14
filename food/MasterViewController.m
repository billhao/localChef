//
//  MasterViewController.m
//  food
//
//  Created by Hao Wang on 6/18/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "FoodItemView.h"
#import "MenuCell.h"
#import "Global.h"
#import "totUtility.h"
#import "UIImageView+WebCache.h"

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
    
    currentOrder = nil;
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
//    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    [self.tableView setTableHeaderView: v];

    noItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 160)];
    noItemLabel.lineBreakMode = NSLineBreakByWordWrapping;
    noItemLabel.numberOfLines = 0;
    noItemLabel.font = [UIFont fontWithName:@"Helvetica Neue Thin" size:20];
    noItemLabel.textColor = [UIColor grayColor];
    noItemLabel.textAlignment = NSTextAlignmentCenter;
    noItemLabel.hidden = true;
    [self.view insertSubview:noItemLabel aboveSubview:self.tableView];

    searchBar.inputAccessoryView = [self createInputAccessoryView];

    // init activity indicator
    //activityIndicator = [[ActivityIndicatorView alloc] init];
    //[self.view addSubview:activityIndicator.view];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.alpha = 0.4;
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];

    // load search bar default zip code
    NSString* defaultZip = [totUtility getSetting:@"searchLocation"];
    if( defaultZip == nil ) defaultZip = @"";
    searchBar.text = defaultZip;
}

- (void)viewDidAppear:(BOOL)animated {
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshData {
    if (!objects) {
        objects = [[NSMutableArray alloc] init];
    }
    else
        [objects removeAllObjects];

    NSString* location = searchBar.text;
    
    if( location.length > 0 ) {
        NSLog(@"Loading dishes from %@", location);

        // save as default location
        [totUtility setSetting:@"searchLocation" value:location];

        // start activity indicator
        //[activityIndicator start];

        if( !self.refreshControl.refreshing) {
            [self.refreshControl beginRefreshing];
            int h = self.refreshControl.frame.size.height;
            int hh = self.tableView.contentOffset.y;
            [self.tableView setContentOffset:CGPointMake(0, hh-h) animated:NO];
        }

        NSArray* data = [global.server getDataForLocation:location secret:global.user.secret];
        
        for (NSDictionary* seller in data) {
            NSDictionary* items = seller[@"items"];
            for (NSDictionary* item in items) {
                NSDictionary* dict = (NSDictionary*)[totUtility JSONToObject:item[@"dish_data"]];
                FoodItem* food = [FoodItem fromDictionary:dict food_id:item[@"dish_id"]];
                food.food_stock              = [item[@"stock"] integerValue];
                food.seller_id          = seller[@"seller_id"];
                food.seller_name        = seller[@"seller_name"];
                food.seller_address     = seller[@"seller_address"];
                food.seller_phone       = seller[@"seller_phone"];
                
                [objects addObject:food];
            }
        }
        
        // stop it
        //[NSThread sleepForTimeInterval:20]; // test activity
        //[activityIndicator stop];
    }
    [self.tableView reloadData];
    
    if( objects.count == 0 ) {
        if( location.length == 0 )
            noItemLabel.text = @"Type in your zip code to start a search";
        else
            noItemLabel.text = @"Nothing found in this area. Be the first one to share some food or drink with the neighbors. Or try another Zip Code";
        noItemLabel.hidden = false;
    }
    else
        noItemLabel.hidden = true;
    
    if( self.refreshControl.refreshing)
        [self.refreshControl endRefreshing];

    // scroll to top
    [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top) animated:TRUE];
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
    
    if( f.food_stock == 0 ) {
        cell.soldoutImg.hidden  = false;
        cell.orderButton.hidden = true;
    }
    else {
        cell.soldoutImg.hidden  = true;
        cell.orderButton.hidden = false;
    }
    cell.f_name.text = [NSString stringWithFormat:@"%@", f.food_name];
    cell.f_desc.selectable = YES; // an iOS bug workaround
    cell.f_desc.contentInset = UIEdgeInsetsMake(-2,-2,0,0);
    cell.f_desc.text = [NSString stringWithFormat:@"By %@\n%@\nAvailable between\n%@\n%@\n%@", f.seller_name, f.food_description, [totUtility dateToStringShort:f.food_start_time], [totUtility dateToStringShort:f.food_end_time], f.seller_address];
    cell.f_desc.selectable = NO; // an iOS bug workaround
    double price = f.food_price;
    if( price > 0 ) {
        if( price != (price*100)/100 )
            cell.f_price.text = [NSString stringWithFormat:@"$ %.2f", f.food_price];
        if( price != (price*10)/10 )
            cell.f_price.text = [NSString stringWithFormat:@"$ %.1f", f.food_price];
        else
            cell.f_price.text = [NSString stringWithFormat:@"$ %.0f", f.food_price];
    }
    else
        cell.f_price.text = @"Free";
    
    UIImage* placeHolderImage = [UIImage imageNamed:@"place_holder_buyer_list_page"];
    if( f.food_image_url && f.food_image_url.length > 0 ) {
//        UIImage* img = [global.server downloadPhoto:f.food_image_url];
//        cell.f_image.image = img;
        [cell.f_image sd_setImageWithURL:[global.server getImageURL:f.food_image_url] placeholderImage:placeHolderImage];
    }
    else {
        cell.f_image.image = placeHolderImage;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
    currentOrder = objects[index];
    NSString* msg = [NSString stringWithFormat:@"Please confirm your order of %@", currentOrder.food_name];
    [totUtility showConfirmation:msg delegate:self];
//    [global.order addObject:objects[index]];
//    NSLog(@"add item to order. now order size = %lu", global.order.count);
//    for (int i=0; i<global.order.count; i++) {
//        [(FoodItem*)global.order[i] toString];
//    }
    
}

- (void)placeOrder {
    NSString* order_id = [global.server addOrder:currentOrder.food_id];
    if( order_id != nil ) {
        // order successful, go to order list page
        [self performSegueWithIdentifier:@"goToBuyerOrderListPage" sender:self];
    }
    else {
        // order failed, prompt user and do something
        [totUtility showAlert:@"Something went wrong. Place order failed. Please try order something else"];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)search {
    [self refreshData];
    [search resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if( buttonIndex == 1 ) {
        // YES
        [self placeOrder];
    }
    else
        currentOrder = nil; // clear this order
}

#pragma mark - Helper functions
- (UIView*)createInputAccessoryView{
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView	= [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle		= UIBarStyleDefault;
    keyboardDoneButtonView.translucent	= YES;
    keyboardDoneButtonView.tintColor	= nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton    = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone  target:self action:@selector(searchInputDoneButtonClicked:)];
    
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer1    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil action:nil];
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer, spacer1, doneButton, nil]];
    
    return keyboardDoneButtonView;
}

- (void)searchInputDoneButtonClicked: (id *)control {
    [searchBar resignFirstResponder];
    [self searchBarSearchButtonClicked:searchBar];
}



@end
