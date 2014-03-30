//
//  FlipsideViewController.m
//  ThriftTest
//
//  Created by Charles Lavery on 3/30/14.
//  Copyright (c) 2014 Charles Lavery. All rights reserved.
//

#import "FlipsideViewController.h"
#import "test.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ServiceFactory* services = [ServiceFactory sharedInstance];
    
    [services BulletinBoardClient:^(BulletinBoardClient* client) {
        NSLog(@"Making Add Request");
    
        Message* message = [[Message alloc]initWithText:@"Bob's" date:@"Your Uncle"];
        
        @try {
            [client add:message];
        } @catch(MessageExistsException* e) {
            NSLog(e.message);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    ServiceFactory* services = [ServiceFactory sharedInstance];
    
    [services BulletinBoardClient:^(BulletinBoardClient* client) {
        NSLog(@"Making Get Request");
        
        NSMutableArray* messages = [client get];
        
        for (Message* message in messages) {
            NSLog([NSString stringWithFormat:@"Message<%@, %@>", message.text, message.date]);
        }
        
    }];
    
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
