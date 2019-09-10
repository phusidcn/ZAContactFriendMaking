//
//  DetailViewController.m
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/23/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIStackView *infoStackView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self contact] != nil) {
        [[self contactNameLabel] setText:[NSString stringWithFormat:@"%@ %@", self.contact.familyName, self.contact.givenName]];
        /*
        for (CNLabeledValue *phoneNumber in [[self contact] phoneNumbers]) {
            UIView* phoneNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 393, 128)];
            UILabel* phoneTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 377, 30)];
            NSString * label = phoneNumber.label.uppercaseString;
            [phoneTitleLabel setText:label];
            [phoneNumberView addSubview:phoneTitleLabel];
            UILabel* phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 377, 32)];
            [phoneNumberLabel setText:label];
            [phoneNumberView addSubview:phoneNumberLabel];
            [[self infoStackView] addSubview:phoneNumberView];
        }
         */
        for (int i = 0; i < self.contact.phoneNumbers.count; i++) {
            CNLabeledValue* item = self.contact.phoneNumbers[i];
            UIView* phoneNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 393, 128)];
            UILabel* phoneTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 377, 30)];
            NSString * string = item.label.stringByResolvingSymlinksInPath;
            [phoneTitleLabel setText:string];
            [phoneNumberView addSubview:phoneTitleLabel];
            UILabel* phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 377, 32)];
            
            [phoneNumberLabel setText:string];
            [phoneNumberView addSubview:phoneNumberLabel];
            [[self infoStackView] addSubview:phoneNumberView];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
