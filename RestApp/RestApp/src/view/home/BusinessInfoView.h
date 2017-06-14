//
//  BusinessInfoView.h
//  RestApp
//
//  Created by 刘红琳 on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "MenuSelectHandle.h"

@class NavigateTitle2;
@interface BusinessInfoView : UIViewController<UITableViewDataSource,UITableViewDelegate,INavigateEvent>
{
    NSMutableArray *menuItems;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (strong, nonatomic) IBOutlet UITableView *businessTab;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) id<MenuSelectHandle> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<MenuSelectHandle>)parent;

@end
