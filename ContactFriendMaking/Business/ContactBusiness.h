//
//  ContactBussiness.h
//  ContactFriendMaking
//
//  Created by Huynh Lam Phu Si on 7/28/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//
#import "../DataAccess/ContactInstance.h"
#import "ContactWithStatus.h"
#import "../DataAccess/contactAdapter.h"
#import "../DataAccess/MutableContactList.h"
#import "../DataAccess/PermissionStatus.h"
#import "StatusApplied.h"
#import "ContactUtility.h"
#ifndef ContactBussiness_h
#define ContactBussiness_h
@interface ContactBussiness : NSObject
@property (nonatomic) NSMutableArray<contactWithStatus*>* _Nullable allContacts;
@property (nonatomic) NSMutableDictionary* _Nullable dictionary;
@property (nonatomic) NSMutableArray<NSString*>* _Nullable titleForSection;
@property (nonatomic) NSMutableArray<NSNumber*>* _Nullable sumOfContactToSection;
@property (nonatomic) NSMutableArray<NSNumber*>* _Nullable searchIndexArray;
@property (nonatomic) NSMutableArray<NSNumber*>* _Nullable selectedIndexArray;

- (instancetype _Nonnull) init;
- (dispatch_queue_t _Nonnull ) safeDispatchQueue;
- (void) groupContactToSectionWithCompletion:(void (^_Nullable)(void))completion;

- (void) getAllContacInDevicetWithCompletionHandler:(void(^_Nonnull)(BOOL)) result;
- (void) searchContactWithKey:(NSString*_Nonnull)key completion:(void(^_Nullable)(NSError* _Nullable))completion;
- (void) cancelSearch;

- (void) selectOneContactAtIndex:(NSIndexPath*_Nullable) indexPath completion:(void(^_Nullable)(NSError* _Nullable)) completion;
- (void) deselectContactAtIndex:(NSIndexPath*_Nullable)index completion:(void (^_Nullable)(NSError* _Nullable)) completion;

- (void) selectSearchedContactAt:(NSIndexPath*_Nullable) indexPath completion: (void(^_Nullable)(NSError* _Nullable)) completion;
- (void) deselectSearchedContactAt:(NSIndexPath*_Nullable) indexPath completion:(void(^_Nullable)(NSError* _Nullable)) completion;

- (void) getSelectedContactWithCompletionHandler: (void(^_Nullable)(NSArray<contactWithStatus*>* _Nullable)) completion;
- (void) getSearchedContactWithCompletionHandler:(void(^_Nullable)(NSArray<contactWithStatus*>* _Nullable)) completion;

- (void) chooseContactIsSelectedAt:(NSUInteger)index completion:(void(^ _Nullable)(NSUInteger))completion;

- (NSUInteger) numberOfContactWithSearchingStatus:(BOOL) search;
- (NSUInteger) numberOfContactWithSelectedStatus:(BOOL) select;
- (NSUInteger) numberOfAllContact;

- (NSIndexPath* _Nonnull) convertIndexToIndexPath:(NSUInteger)index;
- (NSUInteger) convertIndexPathToIndex:(NSIndexPath* _Nonnull)indexPath;
@end
#endif /* ContactBussiness_h */
