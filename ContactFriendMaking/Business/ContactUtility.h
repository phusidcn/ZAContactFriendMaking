//
//  ContactUtility.h
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/29/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//
#import "ContactWithStatus.h"
#import <UIKit/UIKit.h>
#ifndef ContactUtility_h
#define ContactUtility_h
@interface contactUtility : NSObject
- (NSString* _Nonnull) getContactFullNameOf:(contactWithStatus* _Nonnull) contact;
- (NSString* _Nonnull) getAvatarOf:(contactWithStatus* _Nonnull) contact;
- (NSString* _Nonnull) getPhoneNumberOf:(contactWithStatus* _Nonnull) contact;
- (UIColor* _Nonnull) getColorOf:(contactWithStatus* _Nonnull) contact;
@end

#endif /* ContactUtility_h */
