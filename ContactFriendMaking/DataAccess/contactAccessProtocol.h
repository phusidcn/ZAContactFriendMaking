//
//  contactAccessLayer.h
//  ContactFriendMaking
//
//  Created by CPU11899 on 8/1/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol contactAccessProtocol <NSObject>
@required
- (void) authorizeContactWithCompletionHandler:(void(^_Nonnull)(authorizationStatus))completion;
- (void) scanContactWithCompletionHandler:(void(^_Nonnull)(MutableContactList*_Nullable))completion;
- (void) requestPermissionWithCompletionHandler:(void(^_Nonnull)(BOOL))completion;
@end

NS_ASSUME_NONNULL_END
