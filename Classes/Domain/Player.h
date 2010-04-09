//
//  Player.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Player : NSObject {
	long playerId;
	int number;
	NSString* shortName;
	NSString* firstName;
	NSString* lastName;
	NSString* position;
	NSArray* teams;
}

@property long playerId;
@property int number;
@property (retain, nonatomic) NSString* shortName;
@property (retain, nonatomic) NSString* firstName;
@property (retain, nonatomic) NSString* lastName;
@property (retain, nonatomic) NSString* position;
@property (retain, nonatomic) NSArray* teams;

- (id) initWith: (int) num : (NSString*) firstName;
- (NSString*) idString;
- (id)proxyForJson;
@end
