//
//  ViewController.m
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "ContactListViewController.h"
#import "ContactTableViewCell.h"
#import "IconCollectionViewCell.h"
#import "../Business/ContactBusiness.h"
#import "../Business/ContactWithStatus.h"
#import "../Business/ContactUtility.h"


@interface ContactListViewController () {
    BOOL _isSearching;
    NSUInteger numberOfRows;
}
#pragma mark - OUTLETS of this viewController
@property (weak, nonatomic) IBOutlet UITableView *contactListTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *contactSearchbar;
@property (weak, nonatomic) IBOutlet UICollectionView *contactSelectedCollectionView;

@property ContactBussiness* bussinessInterface;
@property contactUtility* utility;

@property NSDictionary* displayAllContacts;
@property NSArray<contactWithStatus*>* displaySearchContacts;
@property NSArray<contactWithStatus*>* displaySelectedContacts;
@end

@implementation ContactListViewController

#pragma mark - initialize the main view
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self contactSearchbar] setDelegate:self];
    _isSearching = false;
    [self hideContactCollectionView];
    self.bussinessInterface = [[ContactBussiness alloc] init];
    [[self bussinessInterface] getAllContacInDevicetWithCompletionHandler:^(BOOL canGet) {
        if (canGet) {
            [[self bussinessInterface] groupContactToSectionWithCompletion:^{
                self.displayAllContacts = self.bussinessInterface.dictionary;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self contactListTableView] reloadData];
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertCantAccessContact];
            });
        }
    }];
    self.utility = [[contactUtility alloc] init];
}

#pragma mark - Implementating the UITableView DataSource and Delegate methods
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    if (self->_isSearching) {
        contactWithStatus* contact = [[self displaySearchContacts] objectAtIndex:indexPath.row];
        [[cell titleLabel] setText:[[self utility] getContactFullNameOf:contact]];
        [[cell detailLabel] setText:[[self utility] getPhoneNumberOf:contact]];
        [[cell avatarLabel] setText:[[self utility] getAvatarOf:contact]];
        [[cell avatarLabel] setBackgroundColor:[[self utility] getColorOf:contact]];
        if ([contact isSelected]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    } else {
        NSString* sectionTitle = [NSString stringWithString:[[[self bussinessInterface] titleForSection]objectAtIndex:indexPath.section]];
        NSArray* sectionContacts = [[self displayAllContacts] objectForKey:sectionTitle];
        
        contactWithStatus* contact = [sectionContacts objectAtIndex:indexPath.row];
        [[cell titleLabel] setText:[[self utility] getContactFullNameOf:contact]];
        [[cell detailLabel] setText:[[self utility] getPhoneNumberOf:contact]];
        [[cell avatarLabel] setText:[[self utility] getAvatarOf:contact]];
        [[cell avatarLabel] setBackgroundColor:[[self utility] getColorOf:contact]];
        if ([contact isSelected]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    return cell;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*) tableView {
    return self.bussinessInterface.titleForSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self->_isSearching) {
        return 1;
    } else {
        return self.bussinessInterface.titleForSection.count;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self->_isSearching) {
        return @"";
    } else {
        return [[[self bussinessInterface] titleForSection] objectAtIndex:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self->_isSearching) {
        return self.displaySearchContacts.count;
    } else {
        NSString* sectionTitle = [NSString stringWithString:[[[self bussinessInterface] titleForSection]objectAtIndex:section]];
        return [[[self displayAllContacts] objectForKey:sectionTitle] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark) {
        if (self->_isSearching){
            [[self bussinessInterface] deselectSearchedContactAt:indexPath completion:^(NSError* error) {
                [self updateUIWhenUserSelectContactWithError:error];
            }];
        } else {
            [[self bussinessInterface] deselectContactAtIndex:indexPath completion:^(NSError* error) {
                [self updateUIWhenUserSelectContactWithError:error];
            }];
        }
    } else {
        if (self->_isSearching) {
            [[self bussinessInterface] selectSearchedContactAt:indexPath completion:^(NSError* error) {
                [self updateUIWhenUserSelectContactWithError:error];
            }];
        } else {
            [[self bussinessInterface] selectOneContactAtIndex:indexPath completion:^(NSError* error) {
                [self updateUIWhenUserSelectContactWithError:error];
            }];
        }
    }
}

- (void) updateUIWhenUserSelectContactWithError:(NSError*) error {
    if (error == nil) {
        [[self bussinessInterface] getSelectedContactWithCompletionHandler:^(NSArray<contactWithStatus*>* selectedArray){
            self.displaySelectedContacts = [[NSArray alloc] initWithArray:selectedArray];
            self.displayAllContacts = self.bussinessInterface.dictionary;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.displaySelectedContacts.count > 0) {
                    [self showContactCollectionView];
                } else {
                    [self hideContactCollectionView];
                }
                [[self contactSelectedCollectionView] reloadData];
                [[self contactListTableView] reloadData];
            });
        }];
    } else {
        
    }
}

#pragma mark - Implementating the UISearchBar Delegate methods
// search when text in search bar did change
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] <= 0) {
        self->_isSearching = false;
        [[self bussinessInterface] cancelSearch];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self contactListTableView] reloadData];
        });
    } else {
        // after 0.5 second when user stop to type in search bar
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            self->_isSearching = true;
            [[self bussinessInterface] searchContactWithKey:searchText completion:^(NSError* error){
                if (error == nil) {
                    [[self bussinessInterface] getSearchedContactWithCompletionHandler:^(NSArray<contactWithStatus*>* result){
                        self.displaySearchContacts = [[NSArray alloc] initWithArray:result];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[self contactListTableView] reloadData];
                        });
                    }];
                }
            }];
        });
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self->_isSearching = false;
    [[self bussinessInterface] cancelSearch];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self contactListTableView] reloadData];
    });
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self->_isSearching = true;
    [[self view] endEditing:true];
}

#pragma mark - Implementing UICollectionViewController delegate method
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    IconCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iconCell" forIndexPath:indexPath];
    [[cell iconLabel] setText:[[self utility] getAvatarOf:[[self displaySelectedContacts] objectAtIndex:indexPath.row]]];
    cell.layer.cornerRadius = cell.frame.size.height / 2;
    [cell setBackgroundColor:[[self utility] getColorOf:[[self displaySelectedContacts] objectAtIndex:indexPath.row]]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self bussinessInterface] numberOfContactWithSelectedStatus:true];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(53, 53);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 20, 5, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[self bussinessInterface] chooseContactIsSelectedAt:indexPath.row completion:^(NSUInteger index){
        NSIndexPath* scrollIndexPatch = [NSIndexPath indexPathForRow:index inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self contactListTableView] scrollToRowAtIndexPath:scrollIndexPatch atScrollPosition:UITableViewScrollPositionTop animated:true];
        });
    }];
}

@end

@implementation ContactListViewController (animation)

- (void) showContactCollectionView {
    [UIView animateWithDuration:0.3 animations:^{
        [[self contactSelectedCollectionView] setFrame:CGRectMake(0, 88, 414, 69)];
        [[self contactSearchbar] setFrame:CGRectMake(0, 157, 414, 44)];
        [[self contactListTableView] setFrame:CGRectMake(0, 201, 414, 695)];
    }];
}

- (void) hideContactCollectionView {
    [UIView animateWithDuration:0.3 animations:^{
        [[self contactSelectedCollectionView] setFrame:CGRectMake(0, 88, 414, 0)];
        [[self contactSearchbar] setFrame:CGRectMake(0, 88, 414, 44)];
        [[self contactListTableView] setFrame:CGRectMake(0, 132, 414, 764)];
    }];
}

@end

#pragma mark - Implementating contactAction category for Contact List View Controller
@implementation ContactListViewController (alertAction)
- (void) alertForTooMuchChooseContact {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Too much contacts" message:@"You can't choose more than 5 contacts" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void) alertCantAccessContact {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Access denied" message:@"This application can't access to your contact" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancel];
    [self presentViewController:alertViewController animated:true completion:nil];
}

@end
