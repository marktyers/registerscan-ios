//
//  AttendanceViewController.m
//  Register Scan
//
//  Created by Mark Tyers on 26/09/2013.
//  Copyright (c) 2013 Mark Tyers. All rights reserved.
//

#import "AttendanceViewController.h"
#import "FirstAppDelegate.h"

@interface AttendanceViewController ()
@property (nonatomic, retain)NSArray *students;
@property (nonatomic, retain)NSString *studentid;
@end

@implementation AttendanceViewController

@synthesize moduleCode = _moduleCode;
@synthesize type = _type;
@synthesize students = _students;
@synthesize studentid = _studentid;

- (void) loadData {
    FirstAppDelegate *appDelegate = (FirstAppDelegate*) [[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    NSString *url = [NSString stringWithFormat:@"http://creative.coventry.ac.uk/~mtyers/register/v1/index.php/attendance/attendees/%@/%@/%@/", self.moduleCode, self.type, appDelegate.userToken];
    NSLog(@"url: %@", url);
    NSURL *jsonUrl = [NSURL URLWithString: url];
    NSData *data = [NSData dataWithContentsOfURL: jsonUrl];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    self.students = [json valueForKey:@"students"];
    
    //NSLog(@"%@", students);
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [self loadData];
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
    self.title = self.type;
    
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
    return self.students.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = @"BLAH";
    NSString *name = [[self.students valueForKey:@"name"]objectAtIndex:indexPath.row];
    NSString *time = [[self.students valueForKey:@"time"] objectAtIndex:indexPath.row];
    NSString *img = [[self.students valueForKey:@"portrait"] objectAtIndex:indexPath.row];
    NSString *studentcode = [[self.students valueForKey:@"studentcode"] objectAtIndex:indexPath.row];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    //NSString* imageName = @"0000000.jpg";
    //NSString *path = [[NSBundle mainBundle] pathForResource:studentcode ofType:@"jpg"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", studentcode]];
    
    NSLog(@"1. load path: %@", path);
    if ([fileMgr fileExistsAtPath:path]) {
        NSLog(@"LOCAL FILE");
        //cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", studentcode]];
        //NSLog(@"%@.jpg image exists", [NSString stringWithFormat:@"%@.jpg", studentcode]);
        cell.imageView.image = [UIImage imageWithContentsOfFile:path];
    } else {
        //NSLog(@"image does not exist");
        NSRange range = [img rangeOfString:@"0000000.jpg"];
        if (range.length > 0 ) {
            NSLog(@"DEFAULT IMAGE");
            UIImage *imgName = [UIImage imageNamed:@"0000000.jpg"];
            cell.imageView.image = imgName;
        } else {
            // we need to check if the file exists locally and download if not...
            
            NSLog(@"REMOTE IMAGE");
            NSURL *imgUrl = [NSURL URLWithString:img];
            
            UIImage *theImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imgUrl]];
            NSData *imgData = [NSData dataWithData:UIImageJPEGRepresentation(theImage, 1.0f)];
            
            //save image to path
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", studentcode]];
            NSLog(@"2. save path: %@", localFilePath);
            [imgData writeToFile:localFilePath atomically:YES];
            
            //check saving images to directory!!!
            
            cell.imageView.image = [UIImage imageWithData:imgData];
        }
    }
    
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = time;
    
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

- (IBAction)scan:(UIBarButtonItem *)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    [self presentViewController:reader animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    FirstAppDelegate *appDelegate = (FirstAppDelegate*) [[UIApplication sharedApplication] delegate];
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for (symbol in results) break;
    self.studentid = symbol.data;
    //NSLog(@"%@", self.studentid);
    // modulecode=101CDE&type=lecture&studentcode=4222316
    //NSString *urlString = @"http://creative.coventry.ac.uk/~mtyers/register/v1/index.php/modules/mark_present/505cb3f7b9c312.95171125";
    NSString *urlString = [NSString stringWithFormat:@"http://creative.coventry.ac.uk/~mtyers/register/v1/index.php/modules/mark_present/%@", appDelegate.userToken];
    NSString *keys = [NSString stringWithFormat:@"modulecode=%@&type=%@&studentcode=%@", self.moduleCode, self.type, self.studentid];
    NSLog(@"keys: %@", keys);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keys dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSLog(@"responseData: %@", responseData);
    [self loadData];
    //NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self]; // runs req.
    //[self performSelector:@selector(loadData) withObject:self afterDelay:0.5];
    //[self loadData];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
