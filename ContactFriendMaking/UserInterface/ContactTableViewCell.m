//
//  ContactTableViewCell.m
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarLabel.frame = CGRectMake(20, 11, 53, 53);
    self.avatarLabel.layer.masksToBounds = true;
    self.avatarLabel.layer.cornerRadius = self.avatarLabel.frame.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
