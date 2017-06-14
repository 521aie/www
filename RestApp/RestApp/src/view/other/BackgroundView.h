//
//  BackgroundView.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-24.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupBoxViewController.h"
#import "SelectImageItem.h"
#import "INavigateEvent.h"

@class NavigateTitle2,BgView;
@interface BackgroundView : PopupBoxViewController<INavigateEvent>
{
    NSMutableArray *imageItems;
    
    SelectImageItem *currentSelectedImageItem;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollContainer;

- (void)selectBackground:(SelectImageItem *)selectImageItem;

@end
