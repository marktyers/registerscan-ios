//
//  ModulesViewController.m
//  Register Scan
//
//  Created by Mark Tyers on 26/09/2013.
//  Copyright (c) 2013 Mark Tyers. All rights reserved.
//

#import "ModulesViewController.h"
#import "FirstAppDelegate.h"
#import "RegisterTypeViewController.h"

@interface ModulesViewController ()
@property (nonatomic, retain) NSArray *tableData;
@end

@implementation ModulesViewController

BOOL dataFound;

@synthesize tableData = _tableData;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowTypes"]) {
        NSLog(@"ShowTypes segue");
        RegisterTypeViewController *rtvc = segue.destinationViewController;
        NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
        NSString *code = [[self.tableData valueForKey:@"code"]objectAtIndex:selectedPath.row];
        rtvc.moduleCode = code;
    }
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    FirstAppDelegate *appDelegate = (FirstAppDelegate*) [[UIApplication sharedApplication] delegate];
    NSString *userToken = appDelegate.userToken;
    NSLog(@"module, token: %@", userToken);
    if (!userToken || [userToken isEqualToString:@"NO"]) {
        NSLog(@"not logged in");
        [self performSegueWithIdentifier:@"LogIn" sender:nil];
        [self loadModules];
    } else {
        NSLog(@"is logged in");
        [self loadModules];
    }
}// end viewWillAppear.

- (void) loadModules {
    FirstAppDelegate *appDelegate = (FirstAppDelegate*) [[UIApplication sharedApplication] delegate];
    NSError *error;
    NSString *url = [NSString stringWithFormat:@"http://creative.coventry.ac.uk/~mtyers/register/v1/index.php/modules/list/%@/", appDelegate.userToken];
    NSLog(@"URL: %@", url);
    NSURL *jsonUrl = [NSURL URLWithString:url];
    NSData *newData = [NSData dataWithContentsOfURL:jsonUrl];
    if (newData) {
        dataFound = YES;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:newData options:kNilOptions error:&error];
        self.tableData = [json valueForKey:@"modules"];
        [self.tableView reloadData];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataFound) {
        NSLog(@"rows: %i", self.tableData.count);
        return self.tableData.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (dataFound) {
        NSString *code = [[self.tableData valueForKey:@"code"]objectAtIndex:indexPath.row];
        NSString *description = [[self.tableData valueForKey:@"description"] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = code;
        cell.detailTextLabel.text = description;
    } else {
        cell.textLabel.text = @" ";
        cell.detailTextLabel.text = @" ";
    }
    
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)logout:(UIBarButtonItem *)sender {
}
@end
