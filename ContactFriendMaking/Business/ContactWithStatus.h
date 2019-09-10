//
//  ContactStatus.h
//  ContactFriendMaking
//
//  Created by Huynh Lam Phu Si on 7/28/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//
#import "../DataAccess/ContactInstance.h"
#import "StatusApplied.h"
#ifndef ContactStatus_h
#define ContactStatus_h
@interface contactWithStatus : NSObject
@property contactInstance* instance;
@property BOOL isSelected;
- (instancetype) init;
- (instancetype) initContact:(contactInstance*)contact WithIsSelected:(BOOL)selected;
@end

#endif /* ContactStatus_h */
