//
//  SecondMenuView.h
//  RestApp
//
//  Created by zxh on 14-3-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "MenuSelectHandle.h"

@class NavigateTitle2;
@interface SecondMenuView : UIViewController<UITableViewDataSource,UITableViewDelegate,INavigateEvent>
{
    
}
@property (nonatomic, strong)NSMutableArray *menuItems;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) id<MenuSelectHandle> delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableSeMenus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<MenuSelectHandle>)parent;
- (void) loadData;
@end
