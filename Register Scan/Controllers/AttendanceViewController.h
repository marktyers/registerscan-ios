//
//  AttendanceViewController.h
//  Register Scan
//
//  Created by Mark Tyers on 26/09/2013.
//  Copyright (c) 2013 Mark Tyers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface AttendanceViewController : UITableViewController <ZBarReaderDelegate>
@property (nonatomic, retain)NSString *moduleCode;
@property (nonatomic, retain)NSString *type;
- (IBAction)scan:(UIBarButtonItem *)sender;
@end
