//
//  User.m
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import "User.h"

@implementation User

- (User *) initWithId:(NSInteger) userId contributed:(NSInteger)contributed
{
	self = [super init];
	self.userID = [NSNumber numberWithInt:userId];
	self.contributed = [NSNumber numberWithInt:contributed];
	return self;
}

@end
