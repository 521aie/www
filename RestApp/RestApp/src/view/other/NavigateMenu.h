//
//  NavigateMenuView.h
//  RestApp
//
//  Created by zxh on 14-5-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionPickerClient.h"
#import "RemoteResult.h"
#import "MBProgressHUD.h"

@class MainModule,BillModifyService;
@interface NavigateMenu : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    MainModule *mainModule;
    
    BillModifyService *billservice;
    
    NSMutableArray *steps;
    
    NSMutableArray *dataArr;
    
    MBProgressHUD *hud;
}
@property (nonatomic,strong) UINavigationController *rootController;

@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) IBOutlet UILabel *lblMode;
@property (weak, nonatomic) IBOutlet UIView *footerview;
@property (weak, nonatomic) IBOutlet UIImageView *fingerImg;
@property (weak, nonatomic) IBOutlet UIView *guiview;

@property (nonatomic, strong) NSString *selMode;
@property (nonatomic, assign) BOOL isDetailFlag;  //是否详细的标记.
@property (nonatomic, assign) BOOL isWxEnabled;  //是否详细的标记.
@property (nonatomic, strong) NSMutableArray* stepTemps;

//标题数组
@property (nonatomic, strong)NSArray *titilArr;
@property (nonatomic, strong)NSMutableArray *navigateActionArr;
@property (weak, nonatomic) IBOutlet UIButton *Clickbutton;
@property (weak, nonatomic) IBOutlet UIView *showFuview;
@property (weak, nonatomic) IBOutlet UIButton *FuBtn;

@property (nonatomic ,strong)NSMutableArray *OtTArr;
@property (nonatomic ,strong)NSMutableArray *openSArr;
@property (nonatomic ,strong)NSMutableArray *BuSUArr;
@property (nonatomic ,strong)NSMutableArray *PaTSArr;
@property (nonatomic ,strong)NSMutableArray *EnSSArr;
@property (nonatomic ,strong)NSMutableArray *cashireArr;

@property (nonatomic ,strong)NSMutableArray *arry;
@property (nonatomic ,strong)NSMutableArray *arryO;
@property (nonatomic ,strong)NSMutableArray *arrS;
@property (nonatomic ,strong)NSMutableArray *arrT;
@property (nonatomic ,strong)NSMutableArray *arrF;
@property (nonatomic ,strong)NSMutableArray *arrM;

@property (nonatomic, assign) BOOL Billindex;
- (IBAction)btnPopBtn:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)mainModule;
//帮助视频按钮
- (IBAction)btnVideoClick:(id)sender;

- (IBAction)btnShowMainClick:(id)sender;

//功能大全按钮
- (IBAction)btnshowFunction:(id)sender;

- (void)loadInfoData;

- (void)hideguiviewwithiflag:(BOOL)flag;
@end
