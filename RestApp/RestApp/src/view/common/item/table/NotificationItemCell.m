//
//  EnvelopeItemCell.m
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "ImageUtils.h"
#import "ObjectUtil.h"
#import "NSString+Estimate.h"
#import "NotificationItemCell.h"
#import "UIImageView+WebCache.h"

@implementation NotificationItemCell

- (UIImageView *)hotImg {
    if(!_hotImg) {
        _hotImg = [[UIImageView alloc] init];
        _hotImg.image = [UIImage imageNamed:@"ico_msg_hot"];
        _hotImg.frame = CGRectMake(8, 10, 32, 32);
    }
    
    return _hotImg;
}

- (UILabel *)hotLbl {
    if(!_hotLbl) {
        _hotLbl = [[UILabel alloc] init];
        _hotLbl.text = NSLocalizedString(@"新", nil);
        _hotLbl.textColor = [UIColor whiteColor];
        _hotLbl.font = [UIFont boldSystemFontOfSize:12];
        _hotLbl.frame = CGRectMake(8, 10, 32, 32);
        _hotLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _hotLbl;
}

- (UILabel *)titleLbl {
    if(!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont boldSystemFontOfSize:15];
        _titleLbl.numberOfLines = 0;
        _titleLbl.textColor = [UIColor colorWithRed:174/255.0 green:9/255.0 blue:31/255.0 alpha:1];
        _titleLbl.frame = CGRectMake(45, 10, [UIScreen mainScreen].bounds.size.width-60, 32);
    }
    return _titleLbl;
}

- (UIView *)separateLine {
    if(!_separateLine) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
        _separateLine.alpha = 0.8;
        _separateLine.frame = CGRectMake(10, 46, [UIScreen mainScreen].bounds.size.width-20, 1);
    }
    return _separateLine;
}

- (UIImageView *)infoImg {
    if(!_infoImg) {
        _infoImg = [[UIImageView alloc] init];
        CGFloat width = [UIScreen mainScreen].bounds.size.width-20;
        _infoImg.frame = CGRectMake(10, 60, width, 226*width/300);
    }
    return _infoImg;
}

- (UILabel *)contentLbl {
    if(!_contentLbl) {
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.textColor = [UIColor colorWithRed:85/255.0f green:85/255.0f blue:85/255.0f alpha:1];
        _contentLbl.font = [UIFont systemFontOfSize:14];
        _contentLbl.frame = CGRectMake(10, self.infoImg.frame.origin.y+self.infoImg.frame.size.height+10, [UIScreen mainScreen].bounds.size.width-20, 67);
        _contentLbl.numberOfLines = 0;
    }
    return _contentLbl;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.container addSubview:self.hotImg];
    [self.container addSubview:self.hotLbl];
    [self.container addSubview:self.titleLbl];
    [self.container addSubview:self.separateLine];
    [self.container addSubview:self.infoImg];
    [self.container addSubview:self.contentLbl];
    
    [self initItemView];
    
}
- (void)initWithData:(SysNotification *)notification
{
    if ([ObjectUtil isNotNull:notification]) {
        [self renderNoteImg:notification];
        [self renderNoteInfo:notification];
        [self updateViewSize];
    }
}

- (void)initItemView
{
    if (subViews == nil) {
        self.infoImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.infoImg.layer setMasksToBounds:YES];
        subViews = [NSArray arrayWithObjects:self.titleLbl, self.separateLine, self.infoImg, self.contentLbl, nil];
    }
}

- (void)renderNoteImg:(SysNotification *)notification
{
    if ([NSString isNotBlank:notification.server] && [NSString isNotBlank:notification.path]) {
        self.infoImg.hidden = NO;
        NSString *imageUrl = [ImageUtils getImageUrl:notification.server path:notification.path];
        [self.infoImg setContentMode:UIViewContentModeScaleAspectFill];
        [self.infoImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"place_large.png"]];
        self.infoImg.contentMode = UIViewContentModeScaleAspectFit;
       self.infoImg.autoresizesSubviews = YES;
        self.infoImg.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        minLabelHeight = 0;
    } else {
        self.infoImg.hidden = YES;
        minLabelHeight = 20;
    }
}
- (void)renderNoteInfo:(SysNotification *)notification
{
    UIFont *titleFont = [UIFont systemFontOfSize:15];
    CGSize titleSize = [notification.name sizeWithFont:titleFont constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-60, 200) lineBreakMode:NSLineBreakByWordWrapping];
    self.titleLbl.font = titleFont;
    [self.titleLbl setTextAlignment:NSTextAlignmentLeft];
    CGRect titleFrame = self.titleLbl.frame;
    titleFrame.size.height = (titleSize.height>32?titleSize.height:32);
    self.titleLbl.frame = titleFrame;
    self.titleLbl.text = notification.name;
    
    double currentTime = [[NSDate date]timeIntervalSince1970];
    long long noteTime = notification.createTime/1000;
    if (currentTime-noteTime<=7*24*3600) {
        self.hotImg.hidden = NO;
        self.hotLbl.hidden = NO;
        CGRect frame = self.titleLbl.frame;
        frame.origin.x = 45;
        self.titleLbl.frame = frame;
    } else {
        self.hotImg.hidden = YES;
        self.hotLbl.hidden = YES;
        CGRect frame = self.titleLbl.frame;
        frame.origin.x = 10;
        self.titleLbl.frame = frame;
    }
    
    NSString *noteInfo = notification.memo;
    if ([NSString isBlank:noteInfo]) {
        noteInfo = NSLocalizedString(@"无此系统消息", nil);
    }
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [noteInfo sizeWithFont:font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    self.contentLbl.font = font;
    
    self.contentLbl.textColor = [UIColor darkGrayColor];
    [self.contentLbl setTextAlignment:NSTextAlignmentLeft];
    CGRect contentFrame = self.contentLbl.frame;
    contentFrame.size.height = size.height + 20.0;
    contentFrame.size.height = (contentFrame.size.height>=minLabelHeight?contentFrame.size.height:minLabelHeight);
    self.contentLbl.frame = contentFrame;
    self.contentLbl.text = noteInfo;
}

+ (CGFloat)calculateItemHeight:(SysNotification *)note
{
    if ([ObjectUtil isNotNull:note]) {
        CGFloat totalHeight = 0;
        CGFloat minLabelHeight = 28;
        
        UIFont *titleFont = [UIFont systemFontOfSize:15];
        CGSize titleSize = [note.name sizeWithFont:titleFont constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-60, 200) lineBreakMode:NSLineBreakByWordWrapping];
        
        minLabelHeight+=(titleSize.height>32?titleSize.height:32);
        
        if ([NSString isNotBlank:note.path]) {
            minLabelHeight = 0;
            CGFloat width = [UIScreen mainScreen].bounds.size.width-20;
            totalHeight += 226*width/300;
        }
        
        NSString *noteInfo = note.memo;
        if ([NSString isBlank:noteInfo]) {
            noteInfo = NSLocalizedString(@"无此系统消息", nil);
        }
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [noteInfo sizeWithFont:font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        size.height += 20.0;
        size.height = (size.height>=minLabelHeight?size.height:minLabelHeight);
        totalHeight += size.height;
        totalHeight += 50;
        return totalHeight;
    }
    return 0;
}

- (void)updateViewSize
{
    height = 10;
    for (UIView *view in subViews) {
        if (view.hidden == NO) {
            CGRect frame = view.frame;
            frame.origin.y = height;
            view.frame = frame;
            height += frame.size.height;
        }
    }
    CGRect mainFrame = self.container.frame;
    mainFrame.size.height = height;
    self.container.frame = mainFrame;
    
    CGRect bgFrame = self.containerBg.frame;
    bgFrame.size.height = height + LIFE_INFO_BTM_MARGIN + 10;
    self.containerBg.frame = bgFrame;
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = height + LIFE_INFO_BTM_MARGIN + 10;
    self.frame = viewFrame;
}

@end
