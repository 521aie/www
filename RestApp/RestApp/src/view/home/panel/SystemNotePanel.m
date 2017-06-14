//
//  SystemNotePanel.m
//  RestApp
//
//  Created by 邵建青 on 15/10/15.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HomeView.h"
#import "UIView+Sizes.h"
#import "SystemNotePanel.h"
#import "Masonry.h"

@interface SystemNotePanel ()


@end
@implementation SystemNotePanel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutSubView];
    }
    return self;
}

- (void)layoutSubView
{
    self.background = [[UIView alloc] init];
    self.background.backgroundColor = [UIColor whiteColor];
    self.background.alpha = 0.1;
    self.background.layer.cornerRadius = 4;
    [self addSubview:self.background];
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    UIImageView *trumpetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification_trumpet.png"]];
    [self addSubview:trumpetImageView];
    
    self.lblSysNote = [[UILabel alloc] init];
    self.lblSysNote.textColor = [UIColor whiteColor];
    self.lblSysNote.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.lblSysNote];
    
    self.igvNew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notiNumIconOne.png"]];
    self.igvNew.contentMode = UIViewContentModeScaleAspectFit;
    self.igvNew.hidden = YES;
    
//    self.lblNoteNum = [[UILabel alloc] init];
//    self.lblNoteNum.font = [UIFont systemFontOfSize:10];
//    self.lblNoteNum.textColor = [UIColor whiteColor];
//    self.lblNoteNum.textAlignment = NSTextAlignmentCenter;
////    [self.igvNew addSubview:self.lblNoteNum];
//    [self.lblNoteNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.igvNew);
//    }];
    
    UIImageView *nextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"business_arrow_icon_right"]];
    [self addSubview:nextImageView];
    
    UILabel *lblDetail = [[UILabel alloc] initWithFrame:CGRectZero];
    lblDetail.font = [UIFont systemFontOfSize:13];
    lblDetail.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    lblDetail.text = NSLocalizedString(@"详细", nil);
    lblDetail.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:lblDetail];
    
    self.systemNoteBtn = [[CMButton alloc] init];
    self.systemNoteBtn.client = self;
    [self addSubview:self.systemNoteBtn];
    [self.systemNoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [trumpetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).with.offset(15);
        make.width.equalTo(@18);
        make.height.equalTo(@15);
    }];
    
    [self.lblSysNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trumpetImageView.mas_right).with.offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH - 110));
    }];
    
    [nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@8);
        make.height.equalTo(@13);
    }];
    
    [lblDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@(30));
        make.height.equalTo(@(15));
        make.trailing.equalTo(self).with.offset(-35);
    }];
    
    [self addSubview:self.igvNew];
    [self.igvNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(trumpetImageView.mas_top);
//        make.bottom.equalTo(self.mas_centerY);
        make.centerX.equalTo(trumpetImageView.mas_trailing).with.offset(-2);
        make.width.equalTo(@8);
        make.height.equalTo(@(8));
    }];
    
    [self bringSubviewToFront:self.igvNew];
}
- (void)initWithData:(SysNotification *)notification count:(NSInteger)sysNoteNum
{
    NSNumber *isRead = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNotificationRead"];
    
    self.igvNew.hidden = [isRead boolValue];
//    self.lblNoteNum.hidden = [isRead boolValue];
    
//    [self changeNotiLabelWithCount:sysNoteNum];

    if (notification != nil) {
        NSString *noteStr = [NSString stringWithFormat:NSLocalizedString(@"通知：%@", nil), notification.name];
        self.lblSysNote.text = noteStr;
    }
}

//- (void)changeNotiLabelWithCount:(NSInteger)count
//{
//    if (count > 0 && count < 10) {
////        self.lblNoteNum.text = [NSString stringWithFormat:@"%li", (long)count];
//        self.igvNew.image = [UIImage imageNamed:@"notiNumIconOne.png"];
//        
//        [self.igvNew mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(12));
//        }];
//    } else if (count >= 10 && count <= 99) {
////        self.lblNoteNum.text = [NSString stringWithFormat:@"%li", (long)count];
//        self.igvNew.image = [UIImage imageNamed:@"notiNumIconTwo.png"];
//        [self.igvNew mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(16));
//        }];
//    } else if (count > 99) {
////        self.lblNoteNum.text = @"99+";
//        self.igvNew.image = [UIImage imageNamed:@"notiNumIconThree.png"];
//        [self.igvNew mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(20));
//        }];
//    }
//}

- (void)touchUpInside:(CMButton *)button
{
    if (self.systemNoteBtn==button) {
        if (self.callBack) {
            self.callBack();
        }
//        [homeView forwardSysNotification];
    }
}

@end
