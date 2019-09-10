//
//  ContactFacade.h
//  ContactFriendMaking
//
//  Created by Huynh Lam Phu Si on 7/28/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//
#import "ContactBusiness.h"
#import "../DataAccess/MutableContactList.h"
#import "../DataAccess/contactGetter.h"
#import "../DataAccess/ContactInstance.h"
#ifndef ContactFacade_h
#define ContactFacade_h
@interface contactFacade : NSObject
@property ContactBussiness * _Nullable bussiness;
- (instancetype _Nonnull) init;
- (void) allContactWithCompletion: (void(^_Nullable)(NSArray<contactWithStatus*>* _Nullable, BOOL))completion;
- (void) searchContactWithKey:(NSString*_Nonnull)key completion:(void (^ _Nonnull)(NSArray<contactWithStatus *> * _Nullable))completion;
- (void) selectOneContactAtIndex:(NSUInteger)index completion:(void (^ _Nonnull)(NSArray<contactWithStatus *> * _Nonnull))completion;
- (void) deselectctOneContactAtIndex:(NSUInteger)index completion:(void (^ _Nonnull)(NSArray<contactWithStatus *> * _Nonnull))completion;
- (NSUInteger) numberOfContactsWithSearchingStatus:(statusApplied)searching AndIsSelectedStatus:(statusApplied)selected;
@end

#endif /* ContactFacade_h */
