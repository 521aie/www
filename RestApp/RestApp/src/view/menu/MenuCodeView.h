//
//  MenuCodeView.h
//  RestApp
//
//  Created by xueyu on 16/6/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuModule.h"
#import "MBProgressHUD.h"
#import "MenuService.h"
#import "NavigateTitle2.h"
#import "MemoInputClient.h"
#import "TDFRootViewController.h"

typedef NS_ENUM(NSUInteger,MenuKind){
    Kind_Menu = 0,
    Kind_SuitMenu
};
@interface MenuCodeView : TDFRootViewController<INavigateEvent,MemoInputClient>
{
    MenuModule *parent;
    MenuService *service;
    MBProgressHUD *hud;

}
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UIImageView *imgCode;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *supplementView;
@property (nonatomic, assign) NSInteger event;
@property (nonatomic, strong) NSDictionary *soureDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp;
-(void)loadDataWithMenu:(Menu*)menu kind:(MenuKind)kind event:(NSInteger) event;

@end
