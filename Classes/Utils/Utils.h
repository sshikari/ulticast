//
//  Utils.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface Utils : NSObject {


}

// nilifies nulls. if NSNull, make nil, otherwise return obj.
+ (id) nilify: (id) obj;
+ (int) nilifyInt: (id) obj;

+ (NSString*) valueOrDefault: (NSString*) value : (NSString*) def;
+ (void) showTimeoutAlert : (id) deleg 
						  :	(NSString*) buttonTitle
						  : (NSString*) msg 
						  : (NSString*) okButtonMsg
						  : (NSString*) cancelButtonMsg;

+ (NSArray*) fromJSON: (NSArray*) arrayOfJSONObjects: (Class) clazz; 


// request parsing util
+ (NSDictionary*) requestDataMap : (ASIFormDataRequest*) request;

//  caller responsibility to release view controller
+ (UIViewController*) initSelectListViewController: (NSArray*) dataSource: (id) currentValue: (void*) propertyConst: (NSString*) controllerTitle;

+ (NSError*) createError : (int) code : (NSString*)errorString;

@end
