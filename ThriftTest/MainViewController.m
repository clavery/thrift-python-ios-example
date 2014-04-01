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
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (atomic) NSMutableArray* messagesRows;

@end

@implementation MainViewController

@synthesize messageText;
@synthesize messageDate;
@synthesize tv;

@synthesize messagesRows;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    messagesRows = [[NSMutableArray alloc] init];
    
    tv.delegate = self;
    tv.dataSource = self;
    [tv reloadData];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (IBAction)addMessage:(id)sender
{
    ServiceFactory* services = [ServiceFactory sharedInstance];
    
    [services BulletinBoardClient:^(BulletinBoardClient* client) {
        NSLog(@"Making Add Request");

        Message* message = [[Message alloc]initWithText:messageText.text
                                                   date:messageDate.text];
        
        @try {
            [client add:message];
        } @catch(MessageExistsException* e) {
            NSLog(e.message);
        } @catch(TException* e) {
            NSLog(@"HTTP Transport Exception");
        }
    }];
}

- (IBAction)getMessages:(id)sender
{
    ServiceFactory* services = [ServiceFactory sharedInstance];
    
    [services BulletinBoardClient:^(BulletinBoardClient* client) {
        NSLog(@"Making Get Request");
        
        NSMutableArray* messages;
        
        @try {
            messages = [client get];
        } @catch(TException* e) {
            NSLog(@"HTTP Transport Exception");
            return;
        }

        [messagesRows removeAllObjects];
        
        for (Message* message in messages) {
            NSString* formatted = [NSString stringWithFormat:@"Message<%@, %@>", message.text, message.date];
            NSLog(formatted);
            [messagesRows addObject:formatted];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tv reloadData];
        });
    }];
}

// table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MessageCell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [messagesRows objectAtIndex:indexPath.row];
    
    return cell;
                             
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messagesRows.count;
}

@end
