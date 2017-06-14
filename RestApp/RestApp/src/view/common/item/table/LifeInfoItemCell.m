//
//  EnvelopeItemCell.m
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "ObjectUtil.h"
#import "ImageUtils.h"
#import "BigImageBox.h"
#import "LifeInfoListView.h"
#import "LifeInfoItemCell.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"

@implementation LifeInfoItemCell

+ (id)getInstance:(LifeInfoListView *)parent
{
    LifeInfoItemCell *item = [[[NSBundle mainBundle]loadNibNamed:@"LifeInfoItemCell" owner:self options:nil]lastObject];
    if ([item isKindOfClass:[LifeInfoItemCell class]]) {
        [item initItemView];
        item->parent = parent;
        return item;
    }
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LIFEINFO_ITEM_CELL];
}

- (void)initWithData:(Notification *)notificationTemp
{
    [self.timeBg.layer setCornerRadius:12.0];
    notification = notificationTemp;
    if ([ObjectUtil isNotNull:notification]) {
        [self renderNoteImg];
        [self renderNoteInfo];
        [self updateViewSize];
    }
}

- (void)initItemView
{
    if (subViews == nil) {
        self.infoImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.infoImg.layer setMasksToBounds:YES];
        subViews = [NSArray arrayWithObjects:self.titleLbl, self.kindCardLbl, self.separateLine, self.imageContainer, self.contentLbl, nil];
    }
}

- (void)renderNoteInfo
{
    self.lblOverdue.text = NSLocalizedString(@"已过期", nil);
    CGRect rect1 = self.lblOverdue.frame;
    rect1.origin.y = 9;
    self.lblOverdue.frame = rect1;
    self.lblOverdue.textAlignment = NSTextAlignmentCenter;
    CALayer *layer = [self.lblOverdue layer];
    layer.masksToBounds = YES;
    layer.borderWidth = 1;
    layer.borderColor = [UIColor greenColor].CGColor;
    layer.cornerRadius = 5;
    NSString *kindCardName = NSLocalizedString(@"卡类型:", nil);
    if ([NSString isNotBlank:notification.kindCardName]) {
        kindCardName = [kindCardName stringByAppendingString:notification.kindCardName];
    } else {
        kindCardName = [kindCardName stringByAppendingString:NSLocalizedString(@"全部", nil)];
    }
    self.kindCardLbl.text = kindCardName;
    
    NSString *noteInfo = notification.memo;
    if ([NSString isBlank:noteInfo]) {
        noteInfo = NSLocalizedString(@"店家无此优惠信息", nil);
    }
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [noteInfo sizeWithFont:font constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    self.contentLbl.font = font;
    self.contentLbl.textColor = [UIColor darkGrayColor];
    [self.contentLbl setTextAlignment:NSTextAlignmentLeft];
    CGRect contentFrame = self.contentLbl.frame;
    contentFrame.size.height = size.height + 20.0;
    contentFrame.size.height = (contentFrame.size.height>=minLabelHeight?contentFrame.size.height:minLabelHeight);
    self.contentLbl.frame = contentFrame;
    self.contentLbl.text = noteInfo;
    
    if ([ObjectUtil isNotNull:notification.sendDate]) {
        self.timeLbl.text = [NSString stringWithFormat:@"%@", [DateUtils formatTimeWithTimestamp:notification.createTime type:TDFFormatTimeTypeChineseWithTime]];
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:notification.createTime/1000.0];
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps1 = [[NSDateComponents alloc] init];
        unsigned units1  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
        comps1 = [calendar1 components:units1 fromDate:date1];
        NSDateComponents *comps2 = [[NSDateComponents alloc]init];
        [comps2 setMonth:[comps1 month]];
        [comps2 setDay:[comps1 day]];
        [comps2 setYear:[comps1 year]];
        NSCalendar *calendar2 = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        date1 = [calendar2 dateFromComponents:comps2];
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit;
        comps = [calendar components:unitFlags fromDate:date1 toDate:date options:0];
        NSInteger day = [comps day];
         if (day>90) {
            self.isOverdue = NO;
            self.lblOverdue.hidden = NO;
            UIFont *titleFont = [UIFont systemFontOfSize:15];
            CGSize titleSize = [notification.name sizeWithFont:titleFont constrainedToSize:CGSizeMake(230, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGSize lblSize = [notification.name sizeWithFont:titleFont constrainedToSize:CGSizeMake(MAXFLOAT, 15) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect rect = self.titleLbl.frame;
            rect.origin = CGPointMake(60, 7);
            self.titleLbl.frame = rect;
            self.titleLbl.font = titleFont;
            [self.titleLbl setTextAlignment:NSTextAlignmentLeft];
            CGRect titleFrame = self.titleLbl.frame;
            if (lblSize.width>230)
            {
                CGRect rect1 = self.titleLbl.frame;
                rect1.size = titleSize;
                self.titleLbl.frame = rect1;
            }else
            {
                titleFrame.size.height = 15;
                titleFrame.size.width = lblSize.width;
                self.titleLbl.frame = titleFrame;
            }
            self.titleLbl.textColor = [UIColor grayColor];
            self.titleLbl.text = notification.name;
        }else
        {
            CGRect rect = self.titleLbl.frame;
            rect.origin = CGPointMake(10, 7);
            self.titleLbl.frame = rect;

            UIFont *titleFont = [UIFont systemFontOfSize:15];
            CGSize titleSize = [notification.name sizeWithFont:titleFont constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGSize lblSize = [notification.name sizeWithFont:titleFont constrainedToSize:CGSizeMake(MAXFLOAT, 15) lineBreakMode:NSLineBreakByWordWrapping];
            
            self.titleLbl.font = titleFont;
            [self.titleLbl setTextAlignment:NSTextAlignmentLeft];
            CGRect titleFrame = self.titleLbl.frame;
            if (lblSize.width>280)
            {
                
                CGRect rect1 = self.titleLbl.frame;
                rect1.size = titleSize;
                self.titleLbl.frame = rect1;

                
            }else
            {
                titleFrame.size.height = 15;
                titleFrame.size.width = lblSize.width;
                self.titleLbl.frame = titleFrame;
            }
            
            self.titleLbl.text = notification.name;
            self.isOverdue = NO;
            self.lblOverdue.hidden = YES;
            self.containerBg.backgroundColor = [UIColor whiteColor];
            self.containerBg.alpha = 0.8;
            
        }
    }
    NSLog(@"--->%@",self.titleLbl.text);
}

- (void)renderNoteImg
{
    if ([NSString isNotBlank:notification.server] && [NSString isNotBlank:notification.path]) {
        self.imageContainer.hidden = NO;
        NSString *imagePath = [ImageUtils getImageUrl:notification.server path:notification.path];
        SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
        [manager downloadImageWithURL:[NSURL URLWithString:imagePath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            float totalSize = receivedSize + expectedSize;
            float currentSize = receivedSize;
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                self.imageView.hidden = NO;
                [self renderImageView:image];
            }
        }];
        minLabelHeight = 0;
    } else {
        self.imageContainer.hidden = YES;
        minLabelHeight = 40;
    }
}

- (void)renderImageView:(UIImage *)image
{
    CGFloat iwidth = image.size.width;
    CGFloat iheight = image.size.height;
    
    CGFloat wh = iwidth/iheight;
    CGFloat imageWh = 300/226;
    
    CGFloat imageWidth = 0, imageHeight = 0, imageX = 0, imageY = 0;
    
    if (wh>imageWh) {
        imageX = 0;
        imageWidth = 300;
        imageHeight = imageWidth/wh;
        imageY = (226-imageHeight)/2;
    } else if(wh<imageWh) {
        imageY = 0;
        imageHeight = 226;
        imageWidth = imageHeight*wh;
        imageX = (300-imageWidth)/2;
    }
    
    [self.infoImg setFrame:CGRectMake(imageX, imageY+5, imageWidth, imageHeight)];
    [self.infoImg setImage:image];
}

+ (CGFloat)calculateItemHeight:(Notification *)note
{
    if ([ObjectUtil isNotNull:note]) {
        CGFloat totalHeight = 0;
        CGFloat minLabelHeight = 40;
        
        UIFont *titleFont = [UIFont systemFontOfSize:15];
        CGSize titleSize = [note.name sizeWithFont:titleFont constrainedToSize:CGSizeMake(260, 200) lineBreakMode:NSLineBreakByWordWrapping];
        
        minLabelHeight+=titleSize.height;
        
        if ([NSString isNotBlank:note.server] && [NSString isNotBlank:note.path]) {
            minLabelHeight = 0;
            totalHeight += 272;
        }
        
        NSString *noteInfo = note.memo;
        if ([NSString isBlank:noteInfo]) {
            noteInfo = NSLocalizedString(@"店家无此优惠信息", nil);
        }
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [noteInfo sizeWithFont:font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        size.height += 20.0;
        size.height = (size.height>=minLabelHeight?size.height:minLabelHeight);
        totalHeight += size.height;
        totalHeight += 80;
        return totalHeight;
    }
    return 0;
}

- (IBAction)deleteLifeInfo:(id)sender
{
    [parent removeLifeInfo:notification];
}

- (IBAction)itemBtnClick:(id)sender
{
    if ([NSString isNotBlank:notification.server] && [NSString isNotBlank:notification.path]) {
        [BigImageBox show:notification.server path:notification.path];
    }
}

- (void)updateViewSize
{
    height = LIFE_INFO_TOP_MARGIN;
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
