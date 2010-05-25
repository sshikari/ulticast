//
//  Utils.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "JSONUtils.h"
#import "SBJsonParser.h"
#import "SelectionListViewController.h"

@implementation Utils

+ (NSString*) valueOrDefault: (NSString*) value : (NSString*) def {
	return [value length] == 0 ? def : value;
}

+ (id) nilify: (id) obj {
    return obj == [NSNull null] ? nil : obj;
}

+ (int) nilifyInt: (id) obj {
    return obj == [NSNull null] ? 0 : [obj intValue];
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

+ (NSDictionary*) requestDataMap : (ASIFormDataRequest*) request {
	NSError *error = [request error];
	if (error != nil) { 
		return [NSDictionary dictionaryWithObject:error forKey:@"error"];
	} else if ([request responseStatusCode] != 200) {
		// http error
		NSString *response = [request responseString];
		NSLog(@"Error code: %d : %@", [request responseStatusCode], response);			
		return [NSDictionary dictionaryWithObject:[Utils createError: [request responseStatusCode]: response] 
											forKey:@"error"];

	} else {		
		/*
		 body =     {
			errors =         (
			"The supplied token is either invalid or expired."
			);
		 };
		 header =     {
			code = 3;
			status = error;
		 };
		 }
		 
		 errors =         (
		 {
		 field = teamName;
		 message = "Property [teamName] of class [class com.ulticast.domain.Team] cannot be null";
		 object = "com.ulticast.domain.Team";
		 "rejected-value" = <null>;
		 }
		 );
		*/
		NSString *response = [request responseString];
		NSLog(@"response : %@\n", response);
		SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
		NSDictionary* jsonObject = [jsonParser objectWithString:response];
		NSLog(@"object : %@\n", jsonObject);
		NSDictionary* statusMap = [jsonObject objectForKey:@"header"];	
		
		NSString* status = [statusMap objectForKey:@"status"];
		if ([@"ok" isEqualToString:status]) {
			return [jsonObject objectForKey:@"body"];
		} else {
			// return dictionary with error
			int code = [[statusMap objectForKey:@"code"] intValue];
			NSDictionary *body = [jsonObject objectForKey:@"body"];
			NSArray* errorsList = [body objectForKey:@"errors"];
			if (code == 2) {  // field error
				NSDictionary *errorMap = [errorsList objectAtIndex:0];
				NSMutableDictionary* infoMap = [NSMutableDictionary dictionaryWithDictionary:errorMap];
				NSString* betterErrorString = [NSString stringWithFormat:@"%@ field was invalid. ", [errorMap objectForKey:@"field"]];
				[infoMap setObject:betterErrorString forKey:@"errorString"];
				NSError* error = [NSError errorWithDomain:@"ulticast domain" code:code userInfo:infoMap];
				return [NSDictionary dictionaryWithObject:error forKey:@"error"];					
			} else {
				NSError *customError = [Utils createError: code: [errorsList objectAtIndex:0]]; 
				return [NSDictionary dictionaryWithObject:customError forKey:@"error"];
			}	
		}
	}
}

+ (NSError*) createError : (int) code : (NSString*)errorString {
	NSDictionary *dict = [NSDictionary dictionaryWithObject:errorString forKey:@"errorString"];
	return [NSError errorWithDomain:@"ulticast domain" code:code userInfo:dict];
}

+ (UIViewController*) initSelectListViewController: (NSArray*) dataSource: (id) currentValue: (void*) propertyConst: (NSString*) controllerTitle {	
	SelectionListViewController *selectionTableViewController = [[SelectionListViewController alloc] initWithNibName:@"SelectionListViewController" bundle:nil];
    NSArray *selObject = (currentValue == nil ? [NSArray array] : [NSArray arrayWithObject:currentValue]);
	
    [selectionTableViewController populateDataSource:dataSource
									   havingContext: propertyConst
									 selectedObjects:selObject
									   selectionType:kRadio
										 andDelegate:self];
	
    selectionTableViewController.title = controllerTitle;
    return selectionTableViewController;	
}


@end
