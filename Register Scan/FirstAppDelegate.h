//
//  FirstAppDelegate.h
//  Register Scan
//
//  Created by Mark Tyers on 26/09/2013.
//  Copyright (c) 2013 Mark Tyers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *userToken;
@property (nonatomic) BOOL loggedIn;

@end
