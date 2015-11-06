//
//  XLAlbumCell.m
//  UI_HIGH_1028
//
//  Created by lanou on 15/10/29.
//  Copyright (c) 2015年 xxl. All rights reserved.
//

#import "XLAlbumCell.h"
#import "XLPublishAlbum.h"
#import "UIImageView+WebCache.h"
#import "NSString+XL.h"
@interface XLAlbumCell()

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *playTimesLabel;

@property (strong, nonatomic) IBOutlet UILabel *tracksLabel;

@property (strong, nonatomic) IBOutlet UIImageView *collectImageView;

@property (nonatomic,assign) BOOL isCollect;
@property (strong, nonatomic) IBOutlet UILabel *collectLabel;

@end

@implementation XLAlbumCell


- (void)setPulishAlbum:(XLPublishAlbum *)pulishAlbum {
    _pulishAlbum = pulishAlbum;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:pulishAlbum.coverSmall] placeholderImage:nil];
    
    self.titleLabel.text = pulishAlbum.title;
    self.titleLabel.numberOfLines = 0;
    
    self.timeLabel.text = [NSString getGreaterTenThousandWithNumber:pulishAlbum.shares];
    
    self.playTimesLabel.text = [NSString getGreaterTenThousandWithNumber:pulishAlbum.playTimes];
    
    self.tracksLabel.text = [NSString getGreaterTenThousandWithNumber:pulishAlbum.tracks];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectImageViewTap:)];
    self.collectImageView.userInteractionEnabled = YES;
    [self.collectImageView addGestureRecognizer:tap];
    
}

- (void)collectImageViewTap:(UITapGestureRecognizer *)tap {
    self.isCollect = !self.isCollect;
    
    if (self.isCollect) {
        self.collectImageView.image = [UIImage imageNamed:@"collectkong"];
        self.collectLabel.textColor = [UIColor orangeColor];
        
    } else {
        self.collectImageView.image = [UIImage imageNamed:@"collectman"];
        self.collectLabel.textColor = [UIColor redColor];
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
