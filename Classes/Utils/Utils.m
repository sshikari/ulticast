//
//  Utils.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "JSONUtils.h"

@implementation Utils

+ (NSString*) valueOrDefault: (NSString*) value : (NSString*) def {
	return [value length] == 0 ? def : value;
}

+ (id) nilify: (id) obj {
    return obj == [NSNull null] ? nil : obj;
}

+ (NSArray*) fromJSON: (NSArray*) arrayOfJSONObjects: (Class) clazz {
	// each elements must have initFromDictionary method
	if (arrayOfJSONObjects == nil || arrayOfJSONObjects.count == 0)
		return arrayOfJSONObjects;
	NSMutableArray* convertedArray = [NSMutableArray arrayWithCapacity:arrayOfJSONObjects.count];
	for (int i=0; i<arrayOfJSONObjects.count; i++) {
		[convertedArray addObject: [[clazz alloc] initFromDictionary: [arrayOfJSONObjects objectAtIndex: i]]];
	}
	return convertedArray;
}

+ (void) showTimeoutAlert : (id) deleg 
						  :	(NSString*) buttonTitle
						  : (NSString*) msg 
						  : (NSString*) okButtonMsg
						  : (NSString*) cancelButtonMsg {
	[buttonTitle retain];
	[msg retain];	
	if (okButtonMsg != nil) [okButtonMsg retain];
	[cancelButtonMsg retain];
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:buttonTitle 
														message:msg 
													   delegate:deleg 
											  cancelButtonTitle:cancelButtonMsg 								  
											  otherButtonTitles:okButtonMsg];
	[alertView show];
	[alertView release];				
	[buttonTitle release];
	[msg release];
	if (okButtonMsg != nil)[okButtonMsg release];
	[cancelButtonMsg release];
}


@end
