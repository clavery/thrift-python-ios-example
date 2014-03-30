//
//  MainViewController.m
//  ThriftTest
//
//  Created by Charles Lavery on 3/30/14.
//  Copyright (c) 2014 Charles Lavery. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UITextField *messageDate;

@end

@implementation MainViewController

@synthesize messageText;
@synthesize messageDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)addMessage:(id)sender
{
    ServiceFactory* services = [ServiceFactory sharedInstance];
    
    [services BulletinBoardClient:^(BulletinBoardClient* client) {
        NSLog(@"Making Add Request");
        
        NSString* text = messageText.text;
        
        
        Message* message = [[Message alloc]initWithText:messageText.text
                                                   date:messageDate.text];
        
        @try {
            [client add:message];
        } @catch(MessageExistsException* e) {
            NSLog(e.message);
        }
    }];
}

- (IBAction)getMessages:(id)sender
{
    ServiceFactory* services = [ServiceFactory sharedInstance];
    
    [services BulletinBoardClient:^(BulletinBoardClient* client) {
        NSLog(@"Making Get Request");
        
        NSMutableArray* messages = [client get];
        
        for (Message* message in messages) {
            NSLog([NSString stringWithFormat:@"Message<%@, %@>", message.text, message.date]);
        }
        
    }];
}
@end
