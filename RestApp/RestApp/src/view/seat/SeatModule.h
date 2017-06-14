//
//  SeatModule.h
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@class SingleCheckView, AreaListView,AreaEditView, MBProgressHUD;
@class MainModule, SeatListView, SeatEditView, TableEditView;
@interface SeatModule : UIViewController
{
    MainModule *mainModule;
    
    MBProgressHUD *hud;
}

@property (nonatomic, strong) NSMutableDictionary* registerMap;
@property (nonatomic, strong) SeatListView *seatListView;
@property (nonatomic, strong) SeatEditView *seatEditView;
@property (nonatomic, strong) TableEditView *tableEditView;
@property (nonatomic, strong) AreaListView *areaListView;
@property (nonatomic, strong) AreaEditView *areaEditView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;

- (void)showView:(NSInteger) viewTag;

- (void)loadSeatData;

- (void)backMenu;

-(void)backNavigateMenuView;
@end
