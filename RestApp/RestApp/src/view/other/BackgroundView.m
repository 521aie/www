//
//  BackgroundView.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-24.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BackgroundHelper.h"
#import "SelectImageItem.h"
#import "BackgroundView.h"
#import "NavigateTitle2.h"
#import "BackgroundData.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"

@implementation BackgroundView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imageItems = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"更换背景图";
    [self configLeftNavigationBar:@"ico_cancel.png" leftButtonName:@"关闭"];
    [self initDataView];
//    self.view.hidden = YES;
}

- (void)initDataView
{
    NSMutableArray *backgroundList = [[NSMutableArray alloc]initWithCapacity:10];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_01_min.png" normalBgName:@"bg_01.jpg" blackBgName:@"bg_01b.jpg"]];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_02_min.png" normalBgName:@"bg_02.jpg" blackBgName:@"bg_02b.jpg"]];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_03_min.png" normalBgName:@"bg_03.jpg" blackBgName:@"bg_03b.jpg"]];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_04_min.png" normalBgName:@"bg_04.jpg" blackBgName:@"bg_04b.jpg"]];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_05_min.png" normalBgName:@"bg_05.jpg" blackBgName:@"bg_05b.jpg"]];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_06_min.png" normalBgName:@"bg_06.jpg" blackBgName:@"bg_06b.jpg"]];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_07_min.png" normalBgName:@"bg_07.jpg" blackBgName:@"bg_07b.jpg"]];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_08_min.png" normalBgName:@"bg_08.jpg" blackBgName:@"bg_08b.jpg"]];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_09_min.png" normalBgName:@"bg_09.jpg" blackBgName:@"bg_09b.jpg"]];
    [backgroundList addObject:[[BackgroundData alloc]init:@"bg_10_min.png" normalBgName:@"bg_10.jpg" blackBgName:@"bg_10b.jpg"]];
    
    for (NSUInteger i=0;i<backgroundList.count;++i) {
        BackgroundData *backgroundData = [backgroundList objectAtIndex:i];
        SelectImageItem *selectImageItem = [[SelectImageItem alloc] init];
        selectImageItem.frame = CGRectMake(0, 0, 90, 90);
        [imageItems addObject:selectImageItem];
        CGRect frame = selectImageItem.frame;
        frame.origin.x = (SELECT_IMAGE_ITEM_WIDTH + SELECT_IMAGE_ITEM_GAP)*i;
        selectImageItem.frame = frame;
        [self.scrollContainer addSubview:selectImageItem];
        [selectImageItem initWithBackgroundData:backgroundData parent:self];
        if ([[BackgroundHelper getBackgroundImage] isEqualToString:backgroundData.blackBgName]) {
             currentSelectedImageItem = selectImageItem;
            [currentSelectedImageItem setIsSelected:YES];           
        }
    }
    CGSize contentSize = self.scrollContainer.contentSize;
    contentSize.width = backgroundList.count*SELECT_IMAGE_ITEM_WIDTH;
    self.scrollContainer.contentSize = contentSize;
}

- (void)selectBackground:(SelectImageItem *)selectImageItem
{
    if ([ObjectUtil isNotNull:currentSelectedImageItem]) {
        [currentSelectedImageItem setIsSelected:NO];
    }
    currentSelectedImageItem = selectImageItem;
    [currentSelectedImageItem setIsSelected:YES];
    BackgroundData *backgroundData = [selectImageItem getBackgroundData];
    [BackgroundHelper loadBackground:backgroundData];
}

@end
