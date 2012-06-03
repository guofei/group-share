//
//  GSUpdateItem.h
//  group share
//
//  Created by kaku on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdateDelegate<NSObject>
- (void)UpdateItem:(id)sender;
@end

@interface GSUpdateItem : NSObject <UpdateDelegate>
{
    //Filename of the S3
    NSString *keyName;
    //DynamoDB primarykey
    NSString *primaryKey;
}

- (id)initWithS3KeyName:(NSString *)s3name DynamoKeyName:(NSString *)ddbname;

@end
