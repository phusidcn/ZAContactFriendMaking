//
//  ContactStatus.m
//  ContactFriendMaking
//
//  Created by Huynh Lam Phu Si on 7/28/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactWithStatus.h"

@implementation contactWithStatus

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initContact:(contactInstance *)contact WithIsSelected:(BOOL)selected {
    self = [super init];
    if (self) {
        [self setInstance:contact];
        [self setIsSelected:selected];
    }
    return self;
}

@end
