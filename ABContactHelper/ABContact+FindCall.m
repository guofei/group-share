//
//  ABContact+FindCall.m
//  FindCall
//
//  Created by Aleksandar Vacić on 8.2.12..
//  Copyright (c) 2012. Radiant Tap. All rights reserved.
//

#import "ABContact+FindCall.h"
#import "ABContactStringConstants.h"

@implementation ABContact (FindCall)

- (NSDictionary *) searchDictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSString stringWithFormat:@"%d", self.recordID] forKey:@"recordID"];
	
	if (self.firstname) [dict setObject:self.firstname forKey:FIRST_NAME_STRING];
	if (self.middlename) [dict setObject:self.middlename forKey:MIDDLE_NAME_STRING];
	if (self.lastname) [dict setObject:self.lastname forKey:LAST_NAME_STRING];
	
	if (self.prefix) [dict setObject:self.prefix forKey:PREFIX_STRING];
	if (self.suffix) [dict setObject:self.suffix forKey:SUFFIX_STRING];
	if (self.nickname) [dict setObject:self.nickname forKey:NICKNAME_STRING];
	
	if (self.organization) [dict setObject:self.organization forKey:ORGANIZATION_STRING];
	if (self.jobtitle) [dict setObject:self.jobtitle forKey:JOBTITLE_STRING];
	if (self.department) [dict setObject:self.department forKey:DEPARTMENT_STRING];
	
	if (self.note) [dict setObject:self.note forKey:NOTE_STRING];
	
	if (self.phoneArray != nil) {
		NSString *phones = [self.phoneArray componentsJoinedByString:@"|"];
		phones = [[[[phones stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
		[dict setObject:phones forKey:PHONE_STRING];
	}
	if (self.emailArray != nil)
		[dict setObject:[self.emailArray componentsJoinedByString:@"|"] forKey:EMAIL_STRING];
	if (self.addressArray != nil)
		[dict setObject:[self.addressArray componentsJoinedByString:@"|"] forKey:ADDRESS_STRING];
	if (self.smsArray != nil)
		[dict setObject:[self.smsArray componentsJoinedByString:@"|"] forKey:SMS_STRING];
	if (self.urlArray != nil)
		[dict setObject:[self.urlArray componentsJoinedByString:@"|"] forKey:URL_STRING];
	// if (self.socialArray != nil)
	// 	[dict setObject:[self.socialArray componentsJoinedByString:@"|"] forKey:SOCIAL_STRING];
	
	return dict;
}

- (NSUInteger) numberOfMatchesForSearchTerm:(NSString *)searchText {
	NSUInteger ret = 0;
	
	NSArray *allKeys = [self.searchDictionaryRepresentation allKeys];
	NSArray *allValues = [self.searchDictionaryRepresentation allValues];
	
//	DLog(@"\nValues count = %d", [allValues count]);
	
	BOOL shouldSkipName = NO;
	BOOL shouldSkipOrganization = NO;
	
	if (self.lastname == nil && self.firstname == nil ) {
		shouldSkipOrganization = YES;
	} else {
		shouldSkipName = YES;
	}

	NSUInteger i = 0;
	for (NSString *item in allValues) {
//		DLog(@"\nLooking at %d. %@ = %@", i, [allKeys objectAtIndex:i], item);
		
		if (shouldSkipName && [[allKeys objectAtIndex:i] isEqualToString:FIRST_NAME_STRING]) {i++;continue;}
		if (shouldSkipName && [[allKeys objectAtIndex:i] isEqualToString:LAST_NAME_STRING]) {i++;continue;}
		if (shouldSkipOrganization && [[allKeys objectAtIndex:i] isEqualToString:ORGANIZATION_STRING]) {i++;continue;}
		
		if ([item rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//			DLog(@"\nFound!");
			ret++;
		}
			
		i++;
	}
	
	return ret;
}

@end
