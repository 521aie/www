//
//  MenuAreaPrinterEditView.m
//  RestApp
//
//  Created by xueyu on 16/2/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "UIHelper.h"
#import "Area.h"
#import "HelpDialog.h"
#import "NameItemVO.h"
#import "SystemUtil.h"
#import "XHAnimalUtil.h"
#import "ZmTableCell.h"
#import "ColorHelper.h"
#import "RemoteResult.h"
#import "PantryRender.h"
#import "UIView+Sizes.h"
#import "TDFTransService.h"
#import "ServiceFactory.h"
#import "MultiCheckView.h"
#import "PantryPlanArea.h"
#import "TDFOptionPickerController.h"
#import "TransModuleEvent.h"
#import "NSString+Estimate.h"
#import "MenuAreaPrinterEditView.h"
#import "TDFMediator+SupplyChain.h"
#import "TDFSeatService.h"
#import "TDFRootViewController+FooterButton.h"

@interface MenuAreaPrinterEditView ()

@property (strong, nonatomic) TDFSeatService *seatService;

@end

@implementation MenuAreaPrinterEditView
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        transService=[ServiceFactory Instance].transService;
        self.seatService = [[TDFSeatService alloc] init];
        hud=[[MBProgressHUD alloc] initWithView:self.view];
        self.pantryPlanAreas = [[NSMutableArray alloc]init];
        clientSocket = [[AsyncSocket alloc] initWithDelegate:self];
        [clientSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        self.areaPantry = [[AreaPantry alloc]init];
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    
    [self initNavigate];
    [self initMainGrid];
    [self initNotifaction];
}

#pragma mark - UI
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_scrollView addSubview:self.container];
    }
    return _scrollView;
}
- (UIView *)container {
    if(!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor clearColor];
        _container.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height);
        [_container addSubview:self.settingTitle];
        [_container addSubview:self.lsIP];
        [_container addSubview:self.lsWidth];
        [_container addSubview:self.lsCharCount];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 196,SCREEN_WIDTH, 72);
        view.backgroundColor = [UIColor clearColor];
        [_container addSubview:view];

        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:NSLocalizedString(@"打印测试页", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.frame = CGRectMake(13, 12, SCREEN_WIDTH-26, 45);
        [btn setTitleColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPrintTestPageClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_w.png"] forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"ico_printer.png"];
        image = [UIImage imageWithCGImage:image.CGImage scale:(image.size.width / 32.0f) orientation:UIImageOrientationUp];
        [btn setImage:image forState:UIControlStateNormal];
        [view addSubview:btn];
        
        [_container addSubview:self.titleArea];
        [_container addSubview:self.areaGrid];
        [_container addSubview:self.delBtnView];
        [_container addSubview:self.lblTip];
        
    }
    return _container;
}

- (ItemTitle *)settingTitle {
    if(!_settingTitle) {
        _settingTitle = [[ItemTitle alloc] init];
        [_settingTitle awakeFromNib];
        _settingTitle.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
        _settingTitle.backgroundColor = [UIColor clearColor];
    }
    return _settingTitle;
}

- (EditItemList *)lsIP {
    if(!_lsIP){
        _lsIP = [[EditItemList alloc] init];
        _lsIP.frame = CGRectMake(0, 49, SCREEN_WIDTH, 48);
        _lsIP.backgroundColor = [UIColor clearColor];
    }
    return _lsIP;
}
- (EditItemList *)lsWidth {
    if(!_lsWidth){
        _lsWidth = [[EditItemList alloc] init];
        _lsWidth.frame = CGRectMake(0, 98, SCREEN_WIDTH, 48);
        _lsWidth.backgroundColor = [UIColor clearColor];
    }
    return _lsWidth;
}
- (EditItemList *)lsCharCount {
    if(!_lsCharCount){
        _lsCharCount = [[EditItemList alloc] init];
        _lsCharCount.frame = CGRectMake(0, 147, SCREEN_WIDTH, 48);
        _lsCharCount.backgroundColor = [UIColor clearColor];
    }
    return _lsCharCount;
}

- (UITextView *)lblTip {
    if(!_lblTip) {
        _lblTip = [[UITextView alloc] init];
        _lblTip.frame = CGRectMake(0, 434, SCREEN_WIDTH, 40);
        _lblTip.font = [UIFont systemFontOfSize:14];
        _lblTip.userInteractionEnabled = NO;
    }
    return _lblTip;
}

- (ItemTitle *)titleArea {
    if(!_titleArea) {
        _titleArea = [[ItemTitle alloc] init];
        [_titleArea awakeFromNib];
        _titleArea.frame = CGRectMake(0, 269, SCREEN_WIDTH, 48);
        _titleArea.backgroundColor = [UIColor whiteColor];
    }
    return _titleArea;
}


- (ZMTable *)areaGrid {
    if(!_areaGrid) {
        _areaGrid = [[ZMTable alloc] init];
        [_areaGrid awakeFromNib];
        _areaGrid.frame = CGRectMake(0, 328, SCREEN_WIDTH, 48);
        _areaGrid.backgroundColor = [UIColor blackColor];
    }
    return _areaGrid;
}
- (UIView *)delBtnView {
    if(!_delBtnView) {
        _delBtnView = [[UIView alloc] init];
        _delBtnView.frame = CGRectMake(0, 367, SCREEN_WIDTH, 66);
        UIButton *btnDel = [[UIButton alloc] init];
        [btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        btnDel.frame = CGRectMake(10, 9, SCREEN_WIDTH-20, 44);
        [btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnDel addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        [_delBtnView addSubview:btnDel];
    }
    return _delBtnView;
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}

- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"添加", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    
}

- (void)initMainGrid
{
    self.settingTitle.lblName.text=NSLocalizedString(@"打印机设置", nil);
    [self.lsWidth initLabel:NSLocalizedString(@"打印纸宽度", nil) withHit:nil delegate:self];
    [self.lsIP initLabel:NSLocalizedString(@"打印机IP地址", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsCharCount initLabel:NSLocalizedString(@"每行打印字符数", nil) withHit:nil delegate:self];
    self.titleArea.lblName.text = NSLocalizedString(@"使用此设备打印机点菜单的区域", nil);
    [self.areaGrid initDelegate:self event:PANTRY_AREA_EVENT kindName:@"" addName:NSLocalizedString(@"添选区域...", nil) itemMode:ITEM_MODE_DEL isWaring:NO];
    self.lblTip.text = NSLocalizedString(@"提示：一个区域只能只能选择一台打印机打印点菜单\n\n什么是分区域点菜单？\n客单下单后不同区域桌位的点菜单要打印在不同的打印机上，例如一楼区域的点菜单打印到一楼打印机，二楼区域的点菜单打印到二楼打印机。\n\n 分区域点菜单在什么时候打印？\n客单下单后，如果此处添加了就会自动打印到指定的打印机上。下单后再补打时，打印到每台设备自身关联的打印机上，与此处设置无关。", nil);
    [self.lblTip setTextColor:[ColorHelper getTipColor6]];
    [self.lblTip sizeToFit];

    self.lsIP.tag = PANTRY_PRINTIP;
    self.lsWidth.tag = PANTRY_ISWIDTH;
    self.lsCharCount.tag = PANTRY_CHARCOUNT;
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    [self.lsIP setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeIPAddress hasSymbol:NO];
    
}

- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_AreaPantryEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_AreaPantryEditView_Change object:nil];
    
}
#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}


#pragma remote
- (void)loadData:(AreaPantry*) tempVO action:(int)action isContinue:(BOOL)isContinue
{
    self.action=action;
    self.areaPantry=tempVO;
    [self.delBtnView setHidden: action== ACTION_CONSTANTS_ADD];
    [self.delBtnView setHeight:action == ACTION_CONSTANTS_ADD ? 0:66];
    [self clearModle];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title = NSLocalizedString(@"添加", nil);
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"确定", nil)];
    } else {

        self.title = NSLocalizedString(@"点菜单分区域打印", nil);
       [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
        [[TDFTransService new] getAreaPrinterById:tempVO._id success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull dataSource) {
            [hud hideAnimated:YES];
            NSDictionary *data = [dataSource objectForKey:@"data"];
            
            if ([ObjectUtil isEmpty:data]) {
                return;
            }
            self.areaPantry.paperWidth = [ObjectUtil getShortValue:data key:@"paperWidth"];
            NSMutableArray *areaList = [data objectForKey:@"areaList"];
            self.pantryPlanAreas= [JsonHelper transList:areaList objName:@"Area"];
            self.areaPantry.areaList = [self.pantryPlanAreas mutableCopy];
            [self fillModel];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
    [self.titleBox editTitle:NO act:self.action];
    [self.scrollView setContentOffset:CGPointMake(0,0)];
}

-(void)loadFinish:(RemoteResult *)result{

    [hud hideAnimated:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];
    NSDictionary *data = [map objectForKey:@"data"];
    
    if ([ObjectUtil isEmpty:data]) {
        return;
     }
    self.areaPantry.paperWidth = [ObjectUtil getShortValue:data key:@"paperWidth"];
    NSMutableArray *areaList = [data objectForKey:@"areaList"];
    self.pantryPlanAreas= [JsonHelper transList:areaList objName:@"Area"];
    self.areaPantry.areaList = [self.pantryPlanAreas mutableCopy];
    [self fillModel];


}

#pragma mark 数据处理

-(void)clearModle{
    self.titleBox.imgMore.image = [UIImage imageNamed:Head_ICON_OK];
    [self.pantryPlanAreas removeAllObjects];
    [self.lsIP initData:nil withVal:nil];
    [self.lsWidth initData:@"58mm" withVal:@"58"];
    [self.lsCharCount initData:NSLocalizedString(@"32个字符", nil) withVal:@"32"];
    [self.areaGrid loadData:nil detailCount:0];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void)fillModel{
    
    [self.lsIP initData:self.areaPantry.ipAddress withVal:self.areaPantry.ipAddress];
    NSString* paperWidthStr=[NSString stringWithFormat:@"%d",self.areaPantry.paperWidth];
    NSString* paperWidthNameStr=[NSString stringWithFormat:@"%dmm",self.areaPantry.paperWidth];
    [self.lsWidth initData:paperWidthNameStr withVal:paperWidthStr];
    NSString* charCountStr=[NSString stringWithFormat:@"%d",self.areaPantry.rowNum ];
    NSString* charCountNameStr=[NSString stringWithFormat:NSLocalizedString(@"%d个字符", nil),self.areaPantry.rowNum];
    [self.lsCharCount initData:charCountNameStr withVal:charCountStr];
    [self.areaGrid loadData:self.pantryPlanAreas detailCount:self.pantryPlanAreas.count];

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
#pragma mark  edititemlist

-(void) onItemListClick:(EditItemList*)obj
{
    [SystemUtil hideKeyboard];
    if (obj.tag==PANTRY_ISWIDTH) {
          TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text options:[PantryRender listWidth] currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[PantryRender listWidth][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    } else if (obj.tag==PANTRY_PRINTIP) {
    } else if (obj.tag==PANTRY_CHARCOUNT) {
        NSString* widthStr=[self.lsWidth getStrVal];
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text options:[PantryRender listLineCounts:widthStr] currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[PantryRender listLineCounts:widthStr][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
}

-(BOOL)pickOption:(id)item event:(NSInteger)event
{
    NameItemVO* vo=(NameItemVO*)item;
    if (event==PANTRY_ISWIDTH) {
        [self.lsWidth changeData:vo.itemName withVal:vo.itemId];
        NSString *widthStr=[self.lsWidth getStrVal];
        NSMutableArray* arrs=[PantryRender listLineCounts:widthStr];
        NameItemVO* charVo=[arrs firstObject];
        [self.lsCharCount changeData:charVo.itemName withVal:charVo.itemId];
    } else if (event==PANTRY_CHARCOUNT) {
        [self.lsCharCount changeData:vo.itemName withVal:vo.itemId];
    }
    return YES;
}
- (void) clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==PANTRY_PRINTIP) {
        if (![NSString isValidatIP:val]) {
            [AlertBox show:NSLocalizedString(@"请输入正确的ip地址。", nil)];
             return;
        }
        [self.lsIP changeData:val withVal:val];
    }
}

#pragma mark 

- (void)showAddEvent:(NSString *)event
{
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.continueEvent=event;
        [self continueAdd:event];

        return;
    } else if (self.action==ACTION_CONSTANTS_EDIT) {
            self.continueEvent=event;
            [self continueAdd:event];
    }
}

- (void)continueAdd:(NSString *)event
{
    if([event isEqualToString:PANTRY_AREA_EVENT])
    {        [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
//            [seatService listArea:@"true" target:self Callback:@selector(loadAreasFinish:)];
        
        __weak __typeof(self) wself = self;
        [self.seatService areasWithSaleOutFlag:@"true" sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            
            [wself loadAreasFinishError:nil obj:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            [wself loadAreasFinishError:error obj:nil];
        }];
        
    }
}

-(void)loadAreasFinishError:(NSError *)error obj:(NSDictionary *)obj{
    [hud hide:YES];

    if (error) {
        [AlertBox show:[error localizedDescription]];
        return;
    }
    
    self.areas = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[Area class] json:obj[@"data"]]];
    [self showAreaMultiCheckView];
}




- (void)showAreaMultiCheckView
{
    NSMutableArray* copyAreas=[self.areas mutableCopy];
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:PANTRY_AREA delegate:self title:NSLocalizedString(@"选择区域", nil) dataTemps:copyAreas selectList:self.pantryPlanAreas needHideOldNavigationBar:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}



#pragma  mark --多选页结果处理.
-(void)multiCheck:(NSInteger)event items:(NSMutableArray*) items
{
     if (event==PANTRY_AREA) {
        NSMutableArray *newList = [NSMutableArray array];
        if (items!=nil && items.count>0) {
            for (Area* area in items) {
                [newList addObject:area];
            }
        }
        self.pantryPlanAreas = newList;
        [self.areaGrid loadData:newList detailCount:newList.count];

        [self.titleBox editTitle:[self hasChanged] act:self.action];

        [UIHelper refreshUI:self.container scrollview:self.scrollView];


   }
}

- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
}
- (void)closeMultiView:(NSInteger)event{
    
}


-(void) delObjEvent:(NSString*)event obj:(id)obj
{
   if ([event isEqualToString:PANTRY_AREA_EVENT]) {
        Area* ppa=(Area*)obj;
       [self.pantryPlanAreas removeObject:ppa];
       [self.areaGrid loadData:self.pantryPlanAreas detailCount:self.pantryPlanAreas.count];
        [self.titleBox editTitle:[self hasChanged] act:self.action];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
   }
}

#pragma mark   删除Del
- (IBAction)btnDeleteClick:(id)sender {
    
    [UIHelper alertView:self.view andDelegate:self andTitle:NSLocalizedString(@"提示", nil) andMessage:NSLocalizedString(@"确定要删除吗？", nil)];
    
}

//删除确认.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:hud];
        [transService deleteAreaPrinter:self.areaPantry._id target:self callback:@selector(delFinish:)];
    }
}


- (void)delFinish:(RemoteResult*) result
{
    [hud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    if (self.callBack) {
        self.callBack();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark save 保存

-(void)save{
    if (![self isValid]) {
        return;
    }
    AreaPantry* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:hud];
    if (self.action == ACTION_CONSTANTS_ADD) {
        [transService saveAreaPrinterSetting:objTemp target:self callback:@selector(remoteFinsh:)];
    } else {
        
        [transService updateAreaPrinterSetting:objTemp target:self callback:@selector(remoteFinsh:)];
        
    }

}

-(AreaPantry*) transMode
{
    AreaPantry* tempUpdate=[AreaPantry new];
    tempUpdate.rowNum=[self.lsCharCount getStrVal].intValue;
    tempUpdate.ipAddress=[self.lsIP getStrVal];
    tempUpdate.paperWidth=[self.lsWidth getStrVal].intValue;
    tempUpdate.areaList = self.pantryPlanAreas;
    tempUpdate._id = self.areaPantry._id;
    return tempUpdate;
}



-(void)remoteFinsh:(RemoteResult*) result{
    
    [hud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
//        NSDictionary *dict = [JsonHelper transMap:result.content];
    if (self.callBack) {
        self.callBack();
    }
    [self.navigationController popViewControllerAnimated:YES];

}



-(BOOL)isValid{
    

    if ([NSString isBlank:[self.lsIP getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"打印机IP不能为空。", nil)];
        return NO;
    }
    if (![NSString isValidatIP:self.lsIP.lblVal.text]) {
        [AlertBox show:NSLocalizedString(@"请输入正确的ip地址。", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsCharCount getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"每行打印字符数不能为空!", nil)];
        return NO;
    }
    if (![NSString isFloat:[self.lsCharCount getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"每行打印字符数不是数字!", nil)];
     return NO;
    }
    if ([ObjectUtil isEmpty:self.pantryPlanAreas]) {
         [AlertBox show:NSLocalizedString(@"选择使用此设备打印机点菜单的区域", nil)];
     return NO;
   }
     return YES;
}




#pragma mark 打印测试
- (IBAction)btnPrintTestPageClick:(id)sender {
    if ([NSString isBlank:[self.lsIP getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"打印机IP不能为空。", nil)];
        return;
    }
    [UIHelper showHUD:NSLocalizedString(@"正在连接", nil) andView:self.view andHUD:hud];
    [self connectHost:[self.lsIP getStrVal]];
}

- (void)connectHost:(NSString *)ip
{
    if ([clientSocket isConnected]) {
        [clientSocket disconnect];
    }
    
    NSError *error = nil;
    [clientSocket connectToHost:ip onPort:9100 withTimeout:30 error:&error];
    if (error) {
        NSLog(@"connectToHost error %@",error);
        [clientSocket disconnect];
    }
}

-(NSString*)getFilePath
{
    NSBundle* bundel=[NSBundle mainBundle];
    NSString* filePath=[bundel pathForResource:@"ep" ofType:@"txt"];
    NSFileManager* fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        return filePath;
    }
    return nil;
}
-(void) printTestData
{
    NSString* path=[self getFilePath];
    NSData* data=[NSData dataWithContentsOfFile:path];
    [clientSocket writeData:data withTimeout:-1 tag:0];
}

#pragma socket delegate
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    [hud hide:YES];
    if ([NSString isNotBlank:err.localizedDescription]) {
       [AlertBox show:NSLocalizedString(@"打印出错，原因：打印机不通或IP设置有误！请检查设置、网络及打印机。", nil)];
    }
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [hud hide:YES];
    [self printTestData];
    [sock readDataWithTimeout:-1 tag:0];
}

- (NSString *)dataToString:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [hud hide:YES];
    [sock readDataWithTimeout:-1 tag:0];
}

- (BOOL)hasChanged
{
    return  self.lsWidth.isChange || self.lsIP.isChange || self.lsCharCount.isChange || ![self.areaPantry.areaList isEqualToArray:self.pantryPlanAreas] ;
}
#pragma mark 帮助
- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"areatransplan"];
}

@end
