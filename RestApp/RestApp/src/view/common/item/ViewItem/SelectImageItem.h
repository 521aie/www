//
//  SelectImageItem.h
//  CardApp
//
//  Created by 邵建青 on 14-2-27.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundData.h"

#define SELECT_IMAGE_ITEM_WIDTH 90
#define SELECT_IMAGE_ITEM_GAP 5
#define SELECT_IMAGE_ITEM_RADIUS 8

@class BackgroundView;
@interface SelectImageItem : UIView
{
    BackgroundData *backgroundData;
    
    BackgroundView *backgroundView;
    
    BOOL isInited;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *selectImg;
@property (nonatomic, retain) IBOutlet UIView *selectBg;

- (void)initWithBackgroundData:(BackgroundData *)backgroundData parent:(BackgroundView *)backgroundView;

- (IBAction)imageBtnClick:(id)sender;

- (void)setIsSelected:(BOOL)isSelected;

- (BackgroundData *)getBackgroundData;

@end
