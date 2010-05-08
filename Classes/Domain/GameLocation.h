//
//  GameLocation.h
//  ulticast
//
//  Created by Richard Chang on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameLocation : NSObject {
	NSString *description;
}

@property (nonatomic, retain) NSString* description;

- (id) initWithDesc: (NSString*) desc;
@end
