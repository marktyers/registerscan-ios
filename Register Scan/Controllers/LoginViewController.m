//
//  LoginViewController.m
//  Register Scan
//
//  Created by Mark Tyers on 26/09/2013.
//  Copyright (c) 2013 Mark Tyers. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstAppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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

- (IBAction)login:(UIButton *)sender {
    NSString *urlString = @"http://creative.coventry.ac.uk/~mtyers/register/v1/index.php/authenticate/login";
    NSString *keys = [NSString stringWithFormat:@"username=%@&password=%@", self.username.text, self.password.text];
    //NSLog(@"keys: %@", keys);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keys dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *response;
    NSError *error;
    NSData *loginData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:loginData options:kNilOptions error:&error];
    //NSLog(@"responseData: %@", json);
    if ([[json valueForKey:@"error"] isEqualToString:@"AuthenticationFailed"]) {
        NSLog(@"LOGIN ERROR");
        self.password.text = @"";
    } else {
        NSLog(@"set this login token: %@", [json valueForKey:@"token"]);
        FirstAppDelegate *appDelegate = (FirstAppDelegate*) [[UIApplication sharedApplication] delegate];
        [appDelegate setUserToken:[json valueForKey:@"token"]];
        NSLog(@"app delegate token set to : %@", [json valueForKey:@"token"]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
