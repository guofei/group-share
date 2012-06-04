//
//  GSDonwloaderTest.m
//  group share
//
//  Created by kaku on 12/06/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GSDonwloaderTest.h"

@implementation GSDonwloaderTest

- (void)setUp
{
    [super setUp];
    operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 3;
    UIProgressView  *downloadProgress = [[UIProgressView alloc] init];
    AsyncDownloader *downloader = [[AsyncDownloader alloc] initWithS3:@"img_2012-06-04 04:49:18 +0000.png" progressView:downloadProgress];
    [operationQueue addOperation:downloader];
    [downloadProgress release];
    [downloader release];
}

- (void)tearDown
{
    [operationQueue cancelAllOperations];
    [operationQueue release];
}

- (void)testGetNearPerson
{
    
}

@end
