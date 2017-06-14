//
//  DataClearView.m
//  RestApp
//
//  Created by zxh on 14-4-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DataClearView.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "UIView+Sizes.h"
#import "MBProgressHUD.h"
#import "SettingService.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "NSString+Estimate.h"
#import "SettingModuleEvent.h"
#import "RemoteResult.h"
#import "ColorHelper.h"
#import "ServiceFactory.h"
#import "DateUtils.h"
#import "GlobalRender.h"
#import "DateUtils.h"
#import "AlertBox.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFOptionPickerController.h"
#import "MenuRender.h"
#import "Platform.h"
#import "RestConstants.h"
#import "RemoteResult.h"
#import "UIViewController+Picker.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFIntroductionHeaderView.h"

@implementation DataClearView

- (void)viewDidLoad
{
    [super viewDidLoad];
    service=[ServiceFactory Instance].settingService;
    self.title = NSLocalizedString(@"营业数据清理", nil);
    [self.view addSubview:self.scrollView];
    [self initNotifaction];
    [self initMainView];
    [self loadData];
}

#pragma mark - UI


- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 );
        [_scrollView addSubview:self.container];
    }
    return _scrollView;
}

- (TDFIntroductionHeaderView *)headerView {
    if (!_headerView) {
        UIImage *iconImage = [UIImage imageNamed:@"shop_data_clear"];
        NSString *description = @"可手动或自动清理指定范围内的营业数据。营业数据是指收银过程中产生的数据，如：账单、预订单、外卖单、报表等。商品、桌位、员工等设置内容不会被清理。";
        _headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description];
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView changeBackAlpha:0.0];
    }
    return _headerView;
}

- (UIView *)container {
    if(!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        _container.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height);
        [_container addSubview:self.headerView];
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 126,SCREEN_WIDTH, 1);
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        [_container addSubview:view];
        
        [_container addSubview:self.kindSelectDate];
        [_container addSubview:self.lsStartDate];
        [_container addSubview:self.kindSelectTime];
        [_container addSubview:self.lsEndDate];
        
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 98,SCREEN_WIDTH, 66);
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.btnClear];
        _btnClearView = view;
        [_container addSubview:view];
        [_container addSubview:self.warningTip];
        
    }
    return _container;
}

- (EditItemList *)kindSelectDate {
    if(!_kindSelectDate) {
        _kindSelectDate = [[EditItemList alloc] init];
        _kindSelectDate.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
        _kindSelectDate.backgroundColor = [UIColor clearColor];
    }
    return _kindSelectDate;
}

- (EditItemList *)lsStartDate {
    if(!_lsStartDate) {
        _lsStartDate = [[EditItemList alloc] init];
        _lsStartDate.frame = CGRectMake(0, 48, SCREEN_WIDTH, 55);
        _lsStartDate.backgroundColor = [UIColor clearColor];
    }
    return _lsStartDate;
}

- (EditItemList *)kindSelectTime {
    if(!_kindSelectTime) {
        _kindSelectTime = [[EditItemList alloc] init];
        _kindSelectTime.frame = CGRectMake(0, 48, SCREEN_WIDTH, 48);
        _kindSelectTime.backgroundColor = [UIColor clearColor];
        _kindSelectTime.hidden = YES;
    }
    return _kindSelectTime;
}

- (EditItemList *)lsEndDate {
    if(!_lsEndDate) {
        _lsEndDate = [[EditItemList alloc] init];
        _lsEndDate.frame = CGRectMake(0, 96, SCREEN_WIDTH, 48);
        _lsEndDate.backgroundColor = [UIColor clearColor];
    }
    return _lsEndDate;
}

- (UIButton *)btnClear {
    if(!_btnClear) {
        _btnClear = [[UIButton alloc] init];
        [_btnClear setTitle:@"清理" forState:UIControlStateNormal];
        _btnClear.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnClear.frame = CGRectMake(10, 11, SCREEN_WIDTH-20, 44);
        [_btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnClear addTarget:self action:@selector(btnClear:) forControlEvents:UIControlEventTouchUpInside];
        [_btnClear setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
    }
    return _btnClear;
}

- (UILabel *)warningTip {
    if(!_warningTip) {
        _warningTip = [[UILabel alloc] init];
        _warningTip.font = [UIFont systemFontOfSize:12];
        _warningTip.textColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
        _warningTip.frame = CGRectMake(10, 200, SCREEN_WIDTH-20, 50);
        _warningTip.numberOfLines = 0;
    }
    return _warningTip;
}

#pragma navigateTitle.

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    if (self.kindSelectTime.hidden == NO) {
        
        [UIHelper alertView:self.view andDelegate:self andTitle:NSLocalizedString(@"提示", nil) andMessage:NSLocalizedString(@"自动清理会根据您设定的频率将营业数据自动清理掉，清理过后数据不可恢复，请谨慎设置。您确定要设置为自动清理营业数据吗？", nil)];
    }
    if (self.kindSelectTime.hidden == YES) {
        self.isAlert = NO;
        [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"停止自动清理营业数据吗？", nil)];
    }

}
- (void)initMainView
{
    [self.kindSelectDate initLabel:NSLocalizedString(@"数据清理方式", nil) withHit:nil delegate:self];
    [self.lsStartDate initLabel:NSLocalizedString(@"▪︎ 开始日期", nil) withHit:nil delegate:self];
    [self.kindSelectTime initLabel:NSLocalizedString(@"▪︎ 自动清理频率", nil) withHit:nil delegate:self];
    [self.lsEndDate initLabel:NSLocalizedString(@"▪︎ 结束日期", nil) withHit:nil delegate:self];

    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    CGRect rect = self.kindSelectTime.frame;
    float x = rect.origin.y - 48;
    rect.origin.y = x;
    self.kindSelectTime.frame = rect;
    _count = 3;
    
    self.kindSelectDate.tag=DATACLEAR_KIND_DATA;
    self.kindSelectTime.tag= DATACLEAR_TIME_DATA;
    self.lsStartDate.tag=DATACLEAR_START_DATE;
    self.lsEndDate.tag=DATACLEAR_END_DATE;
}

- (void)onItemListClick:(EditItemList*)obj
{
    if(obj.tag==DATACLEAR_START_DATE || obj.tag==DATACLEAR_END_DATE){
        
        [self showDatePickerWithTitle:obj.lblName.text mode:UIDatePickerModeDate editItem:obj mininumDate:nil maxinumDate:nil completionBlock:^(NSDate *date) {
            NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
           // NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",dateStr];
//            obj.oldVal = datsFullStr;
//            [obj isChange];
            [obj initData:dateStr withVal:dateStr];
        }];
    }
    if (obj.tag == DATACLEAR_KIND_DATA) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                              options:[MenuRender listDataKind]
                                                                        currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[MenuRender listDataKind][index] event:obj.tag];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    }
    if (obj.tag == DATACLEAR_TIME_DATA) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"自动清理频率", nil)
                                                                              options:[MenuRender listDataTime]
                                                                        currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[MenuRender listDataTime][index] event:obj.tag];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    if (event == DATACLEAR_KIND_DATA) {
        id<INameItem> item = (id<INameItem>)selectObj;
        [self.kindSelectDate changeData:[item obtainItemName] withVal:[item obtainItemId]];
            if ([str isEqualToString:NSLocalizedString(@"手动清理", nil)]){
            if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"自动清理", nil)]) {
                self.kindSelectTime.hidden = NO;
                self.warningTip.text = @"提示：自动清理会根据您设定的频率将营业数据自动删除，清理后数据不可恢复，请谨慎设置。";
                self.lsEndDate.hidden = YES;
                self.lsStartDate.hidden = YES;
                self.btnClear.hidden = YES;
                [self.warningTip setTop:self.kindSelectTime.frame.origin.y + self.kindSelectTime.frame.size.height];
            }
            if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"手动清理", nil)]) {
                self.kindSelectTime.hidden = YES;
                 self.warningTip.text = @"提示：手动清理后系统会立即将指定日期范围内的营业数据删除。清理后数据不可恢复，请谨慎设置。（昨日和今日的营业数据不可清理）";
                self.lsEndDate.hidden = NO;
                self.lsStartDate.hidden = NO;
                self.btnClear.hidden = NO;
                [self.warningTip setTop:self.btnClearView.frame.origin.y + self.btnClearView.frame.size.height];
            }
        }
        if ([str isEqualToString:NSLocalizedString(@"自动清理", nil)]) {
            if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"手动清理", nil)]) {
                self.kindSelectTime.hidden = YES;
                self.lsEndDate.hidden = NO;
                self.lsStartDate.hidden = NO;
                self.btnClear.hidden = NO;
                self.warningTip.text = @"提示：手动清理后系统会立即将指定日期范围内的营业数据删除。清理后数据不可恢复，请谨慎设置。（昨日和今日的营业数据不可清理）";
                self.btnClear.userInteractionEnabled = YES;
                [self.warningTip setTop:self.btnClearView.frame.origin.y + self.btnClearView.frame.size.height];

            }
            if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"自动清理", nil)]) {
                self.kindSelectTime.hidden = NO;
                self.lsEndDate.hidden = YES;
                self.lsStartDate.hidden = YES;
                self.warningTip.text = @"提示：自动清理会根据您设定的频率将营业数据自动删除，清理后数据不可恢复，请谨慎设置。";
                self.btnClear.userInteractionEnabled = YES;
                self.btnClear.hidden = YES;
                [self.warningTip setTop:self.kindSelectTime.frame.origin.y + self.kindSelectTime.frame.size.height];
            }
        }
    }
    if (event == DATACLEAR_TIME_DATA) {
        id<INameItem> item = (id<INameItem>)selectObj;
        [self.kindSelectTime changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"每月1日03:00清理", nil)]) {
            _count = 3;
        }else if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"每周一03:00清理", nil)]){
            _count = 2;
        }else {
            _count = 1;
        }
    }
    return YES;
}
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    if (event==DATACLEAR_START_DATE) {
        [self.lsStartDate initData:dateStr withVal:dateStr] ;
    } else {
        [self.lsEndDate initData:dateStr withVal:dateStr] ;
    }
    return YES;
}


#pragma remote
-(void) loadData
{
    self.kindSelectTime.hidden = YES;
//    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    [self configNavigationBar:NO];
    
    [self.kindSelectDate initData:NSLocalizedString(@"手动清理", nil) withVal:[NSString stringWithFormat:@"%d",DATACLEAR_UNAUTO]];
    [self.kindSelectTime initData:NSLocalizedString(@"每月1日03:00清理", nil) withVal:[NSString stringWithFormat:@"%d",DATACLEAR_MONTH]];
    str= NSLocalizedString(@"手动清理", nil);
    NSDate* date=[NSDate date];
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    [self.lsStartDate initData:dateStr withVal:dateStr];
    [self.lsEndDate initData:dateStr withVal:dateStr];
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [service queryClearTaskTarget:self Callback:@selector(dataCLearQueryFinish:)];
}

#pragma 数据层处理

- (BOOL)isYesterdatOrToday:(NSDate *)date {

    NSCalendar* calendar = [NSCalendar currentCalendar];
    return [calendar isDateInToday:date] || [calendar isDateInYesterday:date];
}

-(BOOL)isValid{
    if ([NSString isBlank:[self.lsStartDate getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请输入开始日期!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsEndDate getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请输入结束日期!", nil)];
        return NO;
    }
    
    NSString *sdateStr = [[self.lsStartDate getStrVal] substringToIndex:10];
    NSString *edateStr = [[self.lsEndDate getStrVal] substringToIndex:10];
    NSDate *sdate = [DateUtils DateWithString:sdateStr type:TDFFormatTimeTypeYearMonthDayString];
    NSDate *edate = [DateUtils DateWithString:edateStr type:TDFFormatTimeTypeYearMonthDayString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowStr = [formatter stringFromDate:[NSDate date]];
    NSDate *nowDate = [DateUtils DateWithString:nowStr type:TDFFormatTimeTypeYearMonthDayString];
    NSComparisonResult result = [sdate compare:edate]; // comparing two dates
    
    if (result==NSOrderedDescending) {
        [AlertBox show:NSLocalizedString(@"开始日期不能大于结束日期!", nil)];
        return NO;
    }
    
    if([edate compare:nowDate] == NSOrderedDescending){
        [AlertBox show:NSLocalizedString(@"结束日期不能大于当前日期!", nil)];
        return NO;
    }
    
    //昨日和今日的数据不可清理
    if ([self isYesterdatOrToday:edate]) {
        [AlertBox show:NSLocalizedString(@"昨日和今日的数据不可清理", nil)];
        return NO;
    }
    
    //0-8点之间数据不可清理
    NSDateFormatter *formatterHour = [[NSDateFormatter alloc] init];
    [formatterHour setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatterHour setTimeZone:timeZone];
    NSString *hour = [formatterHour stringFromDate:[NSDate date]];
    NSRange range = NSMakeRange(11, 2);
    hour = [hour substringWithRange:range];
    NSInteger hourInt = [hour integerValue];
    
    if (0 <= hourInt && hourInt <= 8) {
        [AlertBox show:NSLocalizedString(@"因系统汇总数据，0点至8点期间不可清理营业数据", nil)];
        return NO;
    }
    return YES;
}

- (IBAction)btnClear:(id)sender
{
    if (![self isValid]) {
        return;
    }
    self.isAlert = YES;
    [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确认要进行数据清理吗？", nil)];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isAlert == YES) {
        if (buttonIndex==0) {
            [self showProgressHudWithText:NSLocalizedString(@"正在清理", nil)];
            
             [service dataClearTarget:self Callback:@selector(remoteFinsh:)  startDate:[self.lsStartDate getStrVal] endDate:[self.lsEndDate getStrVal]];

        }
    }
    if (self.isAlert == NO) {
        if (buttonIndex==0) {
            [service closeAutoClearTarget:self Callback:nil];
            if (isnavigatemenupush) {
                isnavigatemenupush =NO;
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [self.navigationController popViewControllerAnimated:YES];
             self.btnClear.userInteractionEnabled = YES;
        } else {
             self.btnClear.userInteractionEnabled = NO;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        return;
    }else{
    
        [service saveOrUpdateTarget:self Callback:nil Integer:_count];
        if (isnavigatemenupush) {
            isnavigatemenupush =NO;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];

    }
    

}
#pragma notification 处理.
-(void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_MenuKabawEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MenuKabawEditView_Change object:nil];
    
}
#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
//    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
    [self configNavigationBar:[UIHelper currChange:self.container]];
}

-(void)remoteFinsh:(RemoteResult*) result
{
    [self.progressHud setHidden:YES];
   
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [AlertBox show:NSLocalizedString(@"数据正在清理中，请稍候5-10分钟查看结果", nil)];
}

//查询用户设置自动定时信息
- (void)dataCLearQueryFinish:(RemoteResult *)result
{
    [self.progressHud setHidden:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary* map=[JsonHelper transMap:result.content];
    
    NSDictionary *dict = map[@"reportTask"];
    NSLog(@"--->%@",map);
    if ([dict isEqual:[NSNull null]]) {
        [self.kindSelectDate initData:NSLocalizedString(@"手动清理", nil) withVal:[NSString stringWithFormat:@"%d",DATACLEAR_UNAUTO]];
        self.kindSelectTime.hidden = YES;
        self.warningTip.text = @"提示：手动清理后系统会立即将指定日期范围内的营业数据删除。清理后数据不可恢复，请谨慎设置。（昨日和今日的营业数据不可清理）";
        [self.warningTip setTop:self.btnClearView.frame.size.height + self.btnClearView.frame.origin.y];
        self.lsEndDate.hidden = NO;
        self.lsStartDate.hidden = NO;
        return;
        
    }
    
    NSNumber *cycle = dict[@"cycle"];
    NSNumber *isOpen = dict[@"isOpen"];
    if ([isOpen isEqualToNumber:@0]) {
        [self.kindSelectDate initData:NSLocalizedString(@"自动清理", nil) withVal:[NSString stringWithFormat:@"%d",DATACLEAR_AUTO]];
        self.kindSelectTime.hidden = NO;
        self.lsEndDate.hidden = YES;
        self.lsStartDate.hidden = YES;
        self.warningTip.text = @"提示：自动清理会根据您设定的频率将营业数据自动删除，清理后数据不可恢复，请谨慎设置。";
        [self.warningTip setTop:self.kindSelectTime.frame.size.height + self.kindSelectTime.frame.origin.y];
        self.btnClear.hidden = YES;
        if ([cycle isEqualToNumber:@1]) {
             [self.kindSelectTime initData:NSLocalizedString(@"每天03:00清理", nil) withVal:[NSString stringWithFormat:@"%d",DATACLEAR_DAY]];
        }else if ([cycle isEqualToNumber:@2]){
             [self.kindSelectTime initData:NSLocalizedString(@"每周一03:00清理", nil) withVal:[NSString stringWithFormat:@"%d",DATACLEAR_MONTH]];
        }else{
            [self.kindSelectTime initData:NSLocalizedString(@"每月1日03:00清理", nil) withVal:[NSString stringWithFormat:@"%d",DATACLEAR_MONTH]];
        }

    }else
    {
        [self.kindSelectDate initData:NSLocalizedString(@"手动清理", nil) withVal:[NSString stringWithFormat:@"%d",DATACLEAR_UNAUTO]];
        self.kindSelectTime.hidden = YES;
        self.lsEndDate.hidden = NO;
        self.lsStartDate.hidden = NO;
        self.warningTip.text = @"提示：手动清理后系统会立即将指定日期范围内的营业数据删除。清理后数据不可恢复，请谨慎设置。（昨日和今日的营业数据不可清理）";
        [self.warningTip setTop:self.btnClearView.frame.size.height + self.btnClearView.frame.origin.y];

    }
    str = self.kindSelectDate.lblVal.text;
    
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"dataclear"];
}

#pragma 比较时间
-(BOOL)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    BOOL ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=YES; break;
            
        case NSOrderedDescending: ci=NO; break;
            //date02=date01
        case NSOrderedSame: ci=YES; break;
        default:
            break;
    }
    return ci;
}
@end
