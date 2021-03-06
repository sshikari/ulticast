//
//  Player.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONUtils.h"
#import "DomainObject.h"

@interface Player : DomainObject<JSONInit> {
	int number;
	NSString* nickname;
	NSString* firstName;
	NSString* lastName;
	NSString* position;
	NSArray* teams;
}

@property int number;
@property (retain, nonatomic) NSString* nickname;
@property (retain, nonatomic) NSString* firstName;
@property (retain, nonatomic) NSString* lastName;
@property (retain, nonatomic) NSString* position;
@property (retain, nonatomic) NSArray* teams;

//- (id) initFromDictionary: (NSDictionary*) dict;

- (id) initWith: (int) num : (NSString*) firstName;
- (NSString*) idString;

@end
