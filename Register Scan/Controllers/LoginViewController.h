//
//  LoginViewController.h
//  Register Scan
//
//  Created by Mark Tyers on 26/09/2013.
//  Copyright (c) 2013 Mark Tyers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(UIButton *)sender;

@end
