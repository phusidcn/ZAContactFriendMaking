//
//  ABContactGetter.h
//  ContactFriendMaking
//
//  Created by CPU11899 on 8/1/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "../DataAccess/PermissionStatus.h"
#import "../DataAccess/MutableContactList.h"
#import "../DataAccess/ContactInstance.h"
#import "../DataAccess/contactAccessProtocol.h"
#ifndef ABContactGetter_h
#define ABContactGetter_h
@interface ABAddressBookGetter : NSObject <contactAccessProtocol>
- (instancetype _Nullable) init;
- (void) authorizeContactWithCompletionHandler:(void(^_Nonnull)(authorizationStatus)) completion;
- (void) scanContactWithCompletionHandler:(void(^ _Nullable)(MutableContactList*_Nullable)) completion;
- (void) requestPermissionWithCompletionHandler:(void(^_Nonnull)(BOOL))completion;
@end

#endif /* ABContactGetter_h */
