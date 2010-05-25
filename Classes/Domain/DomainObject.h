//
//  DomainObject.h
//  ulticast
//
//  Created by Richard Chang on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONUtils.h"

@interface DomainObject : NSObject<NSCoding, JSONInit> {
	long uid;
	long version;
	BOOL dirty;
}

- (id)proxyForJson;

@property BOOL dirty;
@property long uid;
@property long version;
@end
