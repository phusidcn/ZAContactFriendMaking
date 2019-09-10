//
//  ViewController.h
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>

@interface ContactListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate, CNContactViewControllerDelegate, CNContactPickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@end

@interface ContactListViewController (animation)
- (void) showContactCollectionView;
- (void) hideContactCollectionView;
@end

@interface ContactListViewController (alertAction)
- (void) alertForTooMuchChooseContact;
- (void) alertCantAccessContact;
@end
