//
//  CNContactGetter.h
//  ContactFriendMaking
//
//  Created by CPU11899 on 8/1/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//
#import "../DataAccess/PermissionStatus.h"
#import "../DataAccess/MutableContactList.h"
#import "../DataAccess/contactAccessProtocol.h"
#ifndef CNContactGetter_h
#define CNContactGetter_h
@interface CNContactGetter : NSObject <contactAccessProtocol>
- (instancetype _Nullable) init;
- (void) authorizeContactWithCompletionHandler:(void(^_Nonnull)(authorizationStatus)) completion;
- (void) scanContactWithCompletionHandler:(void(^ _Nullable)(MutableContactList*_Nullable)) completion;
- (void) requestPermissionWithCompletionHandler:(void(^_Nonnull)(BOOL))completion;
@end
#endif /* CNContactGetter_h */
