//
//  ABContact+FindCall.h
//  FindCall
//
//  Created by Aleksandar Vacić on 8.2.12..
//  Copyright (c) 2012. Radiant Tap. All rights reserved.
//

#import "ABContact.h"

@interface ABContact (FindCall)

- (NSDictionary *) searchDictionaryRepresentation; // no image, all strings
- (NSUInteger) numberOfMatchesForSearchTerm:(NSString *)searchText;

@end
