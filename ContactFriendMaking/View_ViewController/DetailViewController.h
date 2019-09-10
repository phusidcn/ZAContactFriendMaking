//
//  DetailViewController.h
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/23/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property CNContact* contact;
@end

NS_ASSUME_NONNULL_END
