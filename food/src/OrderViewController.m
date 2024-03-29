//
//  OrderViewController.m
//  food
//
//  Created by Hao Wang on 6/28/14.
//  Copyright (c) 2014 food. All rights reserved.
//

#import "OrderViewController.h"
#import "FoodItem.h"
#import "Global.h"
#import "OrderCell.h"

@interface OrderViewController ()
@end

@implementation OrderViewController

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

    [self updateTotalPrice];
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
    return global.order.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell = (OrderCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    
//    long cnt = global.order.count;
//    
//    NSLog(@"%ld", indexPath.row);
//    FoodItem *f = global.order[indexPath.row];
//    
//    cell.f_name.text = f.food_name;
//    cell.f_desc.text = f.food_description;
//    [cell.f_price setTitle:[NSString stringWithFormat:@"￥%.0f", f.food_price] forState:UIControlStateNormal];
    
    return cell;
}


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
    [self.tableView beginUpdates];
    [global.order removeObjectAtIndex:index];
    NSMutableArray* del = [[NSMutableArray alloc] initWithObjects:path, nil];
    [self.tableView deleteRowsAtIndexPaths:del withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self updateTotalPrice];
}

- (void)updateTotalPrice {
    float total = 0;
    for (FoodItem* f in global.order) {
        total += f.food_price;
    }
    totalLabel.text = [NSString stringWithFormat:@"合计：￥%.2f", total];
}

@end







