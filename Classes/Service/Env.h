//
//  Env.h
//  ulticast
//
//  Created by Richard Chang on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Env : NSObject {
	NSString* hostURL;
}
+ (Env*)sharedInstance;

-(NSURL*) teamAddURL;
-(NSURL*) teamUpdateURL;
-(NSURL*) teamDeleteURL;

@property (nonatomic, retain) NSString* hostURL;
@end
