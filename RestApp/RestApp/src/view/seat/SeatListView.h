//
//  SeatListView.h
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Area.h"
#import <UIKit/UIKit.h>

#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "SelectAreaPanel.h"
#import "MemoInputClient.h"
#import "SingleCheckHandle.h"
#import "OptionPickerClient.h"
#import "DHListSelectHandle.h"
#import "TDFRootViewController.h"

@class FooterListView, NavigateTitle2, SeatListPanel;
@interface SeatListView : TDFRootViewController<INavigateEvent, OptionPickerClient, SingleCheckHandle,MemoInputClient, DHListSelectHandle, UIActionSheetDelegate>
{
    
    SelectAreaPanel *selectAreaPanel;
}
@property (nonatomic, strong) UIButton *managerButton;
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) SeatListPanel *seatListPanel;
@property (nonatomic, strong) UIButton *btnBg;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *seatList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;

@property (nonatomic, strong) Area *currentArea;
@property (nonatomic, assign) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)btnBgClick:(id)sender;

@end
