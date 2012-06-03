//
//  GSDownloadDelegate.h
//  group share
//
//  Created by kaku on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GSDownloadDelegate <NSObject>

- (void)itemHasUpdated:(id)sender itemID:(NSString *)id;

@end
