//
//  User.h
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSNumber *contributed;

- (User *) initWithId:(NSInteger) userId contributed:(NSInteger)contributed;

@end
