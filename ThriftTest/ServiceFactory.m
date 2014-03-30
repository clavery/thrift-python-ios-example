//
//  ServiceFactory.m
//  ThriftTest
//
//  Created by Charles Lavery on 3/30/14.
//  Copyright (c) 2014 Charles Lavery. All rights reserved.
//

#import "ServiceFactory.h"


@implementation ServiceFactory

static ServiceFactory *sharedfactory = nil;

+ (ServiceFactory *)sharedInstance
{
    if (sharedfactory == nil) {
        sharedfactory = [[super allocWithZone:NULL] init];
    }
    return sharedfactory;
}

+ (id)alloc
{
    return [self sharedInstance];
}

- (id) init {
    if ( (self = [super init]) ) {
        queue = [[NSOperationQueue alloc] init];
        queue.name = @"Service Queue";
        queue.MaxConcurrentOperationCount = 1;
    
        [self setUrl:@"http://127.0.0.1:5000/"];
    }
    return self;
}

- (NSString*) url {
    return url;
}

- (void) setUrl: (NSString*)newUrl {
    url = newUrl;
}

- (void) BulletinBoardClient:(void (^)(BulletinBoardClient *))callbackBlock {
    [queue addOperationWithBlock: ^ {
        NSURL *transportUrl = [NSURL URLWithString:url];
        
        THTTPClient* transport = [[THTTPClient alloc] initWithURL:transportUrl];
        TBinaryProtocol* protocol = [[TBinaryProtocolFactory alloc] newProtocolOnTransport:transport];
        BulletinBoardClient* client = [[BulletinBoardClient alloc] initWithProtocol:protocol];
        
        callbackBlock(client);
    }];
}

@end
