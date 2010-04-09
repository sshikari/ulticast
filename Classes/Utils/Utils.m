//
//  Utils.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"


@implementation Utils


+ (NSString*) valueOrDefault: (NSString*) value : (NSString*) def {
	return [value length] == 0 ? def : value;
}


@end
