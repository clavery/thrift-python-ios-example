//
//  MainViewController.h
//  ThriftTest
//
//  Created by Charles Lavery on 3/30/14.
//  Copyright (c) 2014 Charles Lavery. All rights reserved.
//

#import "ServiceFactory.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)addMessage:(id)sender;
- (IBAction)getMessages:(id)sender;

@end
