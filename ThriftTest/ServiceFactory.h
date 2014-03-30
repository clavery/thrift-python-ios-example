//
//  ServiceFactory.h
//  ThriftTest
//
//  Created by Charles Lavery on 3/30/14.
//  Copyright (c) 2014 Charles Lavery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#import "TMemoryBuffer.h"
#import "TTransport.h"
#import "THTTPClient.h"
#import "TBinaryProtocol.h"
#import "test.h"

@interface TAFNetworkingTransport : NSObject <TTransport> {
    NSString* url;
}
@end


@interface ServiceFactory : NSObject {
    NSString* url;
    NSOperationQueue* queue;
}

+ (ServiceFactory *)sharedInstance;

- (NSString*) url;
- (void) setUrl: (NSString*)newUrl;

- (void) BulletinBoardClient:(void (^)(BulletinBoardClient*))callbackBlock;
@end
