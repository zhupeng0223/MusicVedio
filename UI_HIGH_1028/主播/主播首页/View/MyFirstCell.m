//
//  MyFirstCell.m
//  UI_HIGH_1028
//
//  Created by lanou on 15/11/5.
//  Copyright (c) 2015年 xxl. All rights reserved.
//

#import "MyFirstCell.h"
#import "UIImageView+WebCache.h"
#import "MusicTool.h"
@interface MyFirstCell()



@end

@implementation MyFirstCell


- (void)setLoginImageView:(UIImageView *)loginImageView {
    _loginImageView = loginImageView;
    loginImageView.layer.cornerRadius = loginImageView.frame.size.width / 2;
    loginImageView.layer.masksToBounds = YES;
    loginImageView.userInteractionEnabled = YES;
    if ([MusicTool sharedMusicTool].isPlaying) {
        [loginImageView sd_setImageWithURL:[NSURL URLWithString:[MusicTool sharedMusicTool].coverSmallUrl] placeholderImage:nil];
    }
}



- (void)awakeFromNib {
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
