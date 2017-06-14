//
//  TDFHomeView.m
//  RestApp
//
//  Created by 黄河 on 16/9/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define cellTopPadding 4        // cell 上边距
#define cellPadding 4           // cell 内边距
#define cellLeftRightPadding 8  // cell 左右边距
#define padding 8               // 控件间距
//#define businessPanelHeight 245 //营业汇总高度
#define systemNotePanelHeight 35//系统通知高度
#define shopInfoHeight 20       //店家信息高度
#define sectionHeaderHeight 40  //区头高度
#define cellWidth (SCREEN_WIDTH - 2 * cellLeftRightPadding - 3*cellPadding)/4.0
#define cellHeight cellWidth * ((float)90/(float)74)

#import "TDFMainButtonCollectionViewCell.h"
#import "TDFHomeCollectionReusableView.h"
#import "TDFBusinessDetailPanelView.h"
#import "ChainBusinessStatisticsDay.h"
#import "UIImageView+WebCache.h"
#import "BusinessDetailPanel.h"
#import "SysNotificationVO.h"
#import "BusinessSummaryVO.h"
#import "TDFFunctionKindVo.h"
#import "ShopReviewCenter.h"
#import "SystemNotePanel.h"
#import "EventConstants.h"
#import "RestConstants.h"
#import "TDFFunctionVo.h"
#import "AppController.h"
#import "TDFHomeView.h"
#import "SystemEvent.h"
#import "FormatUtil.h"
#import "NumberUtil.h"
#import "JsonHelper.h"
#import "DateUtils.h"
#import "MJRefresh.h"
#import "TDFOtherMenuViewController.h"
#import "EXTScope.h"
#import "Platform.h"
#import "MainUnit.h"
#import "Masonry.h"
#import "AlertBox.h"
#import "TDFIsOpen.h"
#import "TDFRightMenuController.h"

@interface TDFHomeView ()<UICollectionViewDelegate, UICollectionViewDataSource,TDFBusinessDetailPanelViewDelegate,IEventListener>
{
    CGFloat _systemNotePanelHeight;
    UIButton *_leftButton;
    UIImageView *_leftImageView;
}
@property (nonatomic, strong)UIImageView                 *centenImageView;//中间的下拉图标
@property (nonatomic, strong)UIControl                   *centerControl;//中间的点击区域
@property (nonatomic,strong)UIImageView                  *icoSysNotification;//通知的小红点
//@property (nonatomic, strong) UILabel                    *lblNoteNum; // 通知的个数
@property (nonatomic, strong)UILabel                     *titleLabel;//店名

@property (nonatomic, strong)UIView                      *headerView;

@property (nonatomic, strong)UIView                      *headerInfoView;
@property (nonatomic, strong)SystemNotePanel             *systemNotePanel;      //系统通知

//@property (nonatomic, strong) TDFBusinessDetailPanelView *bussinessPanel;   //日营业数据详细面板.
@end
@implementation TDFHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initHeaderView];
        
        [self initCollectionView];
        [SystemEvent registe:REFRESH_SYS_NOTIFICAION target:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshNote)
                                                     name:@"systemNoteRefresh"
                                                   object:nil];
    }
    return self;
}

#pragma mark --下拉刷新
- (void)addRefreshFunction
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadToGetData)]) {
            [self.delegate reloadToGetData];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:NSLocalizedString(@"下拉刷新...", nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"正在刷新...", nil) forState:MJRefreshStateRefreshing];
    [header setTitle:NSLocalizedString(@"下拉刷新...", nil) forState:MJRefreshStatePulling];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.collectView.mj_header = header;
}

#pragma mark --UICollectionViewDelegate, UICollectionViewDataSource

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        [self updateHeaderView];
        return CGSizeMake(SCREEN_WIDTH,self.reuseableViewHeight);
    }
    
    return CGSizeMake(SCREEN_WIDTH,sectionHeaderHeight);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count > 0?self.dataArray.count:1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TDFHomeCollectionReusableView *resusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TDFHomeCollectionReusableView" forIndexPath:indexPath];
    if (indexPath.section < self.dataArray.count) {
        TDFFunctionKindVo *function = self.dataArray[indexPath.section];
        resusableView.titleLabel.text = function.name;
    }
    if (indexPath.section == 0) {
        if (!self.headerInfoView) {
            self.headerInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.reuseableViewHeight)];
            self.headerInfoView.tag = 100;
            [self initHeaderInfoView];
            [resusableView addSubview:self.headerInfoView];
        }else if (![resusableView viewWithTag:100]){
            [resusableView addSubview:self.headerInfoView];
        }
    }else {
        if ([resusableView viewWithTag:100]){
            [[resusableView viewWithTag:100] removeFromSuperview];
        }
    }
    
    return resusableView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section < self.dataArray.count) {
        TDFFunctionKindVo *function = self.dataArray[section];
        return function.functionVoList.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TDFMainButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TDFMainButtonCollectionViewCell" forIndexPath:indexPath];
    cell.isNotShowShadowView = NO;
    if (indexPath.section < self.dataArray.count) {
        TDFFunctionKindVo *function = self.dataArray[indexPath.section];
        if (indexPath.row < function.functionVoList.count) {
            TDFFunctionVo *functionModel = function.functionVoList[indexPath.row];
            [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:functionModel.iconImageUrl.hUrl] placeholderImage:[UIImage imageNamed:@"ico_homeviewplaceImage.png"] options:SDWebImageRefreshCached];
            cell.textLabel.text = functionModel.actionName;
            if ([functionModel.actionCode isEqualToString:@"PAD_KABAW"]) {
                cell.lockImageView.image = functionModel.isLock?[UIImage imageNamed:@"ico_pw_w.png"]:functionModel.isOpen == 0?[UIImage imageNamed:@"ico_pw_red"]:[ShopReviewCenter sharedInstance].shouldShowWarningBadge?[UIImage imageNamed:@"warning_icon_red"]:nil;
            }else
            {
                cell.lockImageView.image = functionModel.isLock?[UIImage imageNamed:@"ico_pw_w.png"]:functionModel.isOpen == 0?[UIImage imageNamed:@"ico_pw_red"]:nil;
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.dataArray.count) {
        TDFFunctionKindVo *function = self.dataArray[indexPath.section];
        if (indexPath.row < function.functionVoList.count) {
            TDFFunctionVo *functionModel = function.functionVoList[indexPath.row];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemWithInfo:)]) {
                [self.delegate didSelectItemWithInfo:functionModel];
            }
        }
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.collectView reloadData];
}


//- (void)initBussinessPanel{
//    self.bussinessPanel.dataTitleArray = @[NSLocalizedString(@"应收(元)", nil),NSLocalizedString(@"折扣(元)", nil),NSLocalizedString(@"损益(元)", nil),NSLocalizedString(@"账单数(单)", nil),NSLocalizedString(@"总客人(人)", nil),NSLocalizedString(@"人均(元)", nil)];
//    self.bussinessPanel.headerView.titleLabel.text = NSLocalizedString(@"营业汇总", nil);
//    self.bussinessPanel.headerView.imageView.image = [UIImage imageNamed:@"ico_next_w.png"];
//}

- (void)initHeaderInfoView
{
    @weakify(self);
    self.systemNotePanel.callBack = ^{
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(goSystermNotification)]) {
            [self.delegate goSystermNotification];
        }
    };
    [self.headerInfoView addSubview:self.systemNotePanel];
//    self.bussinessPanel.delegate = self;
//    self.bussinessPanel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
//    self.bussinessPanel.layer.cornerRadius = 3;
//    [self.headerInfoView addSubview:self.bussinessPanel];
    [self.headerInfoView addSubview:self.businessView];
    [self.businessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.systemNotePanel.mas_bottom);
        make.leading.equalTo(self.headerInfoView);
        make.trailing.equalTo(self.headerInfoView);
        make.bottom.equalTo(self.headerInfoView);
    }];
    
    [self layoutHeaderInfoView];
}


#pragma mark --loadData

- (void)loadInfoWithData:(NSDictionary *)data
{
    [self.collectView.mj_header endRefreshing];
    if (!data) {
        return;
    }
    _leftButton.hidden = _leftImageView.hidden = [[Platform Instance] isBranch];
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];
    self.titleLabel.text = shopName;
    
    if([[Platform Instance] isBranch]) {
        [self dealWithFindNotice:nil];
    }else {
        NSDictionary *findNoticeResultVo = data[@"data"][@"findNoticeResultVo"];
        [self dealWithFindNotice:findNoticeResultVo];
    }
    bool hasOtherEntity = [data[@"data"][@"hasOtherEntity"] boolValue];
    [self dealWithShopList:hasOtherEntity];
//    [self dealWithShopBusinessStatistics:data[@"data"][@"yesterdayVo"]];
}
///营业汇总
//- (void)dealWithShopBusinessStatistics:(NSDictionary *)yestordayDic {
//    if ([[Platform Instance] isBranch]) {
////        self.bussinessPanel.hidden = YES;
////        _businessPanelHeight = 0;
//        [self updateHeaderView];
//        return;
//    }
//    NSTimeInterval secondsPerDay = 24 * 60 * 60;
//    //昨天时间
//    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd"];
//    NSString *yestodayStr = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:yesterday] intValue]];
//    NSString *str = [DateUtils formatTimeWithDate:yesterday type:TDFFormatTimeTypeChineseWithoutYear];
//    NSString *monthStr = [str substringWithRange:NSMakeRange(0,2)];
//    NSString *dayStr = [str substringWithRange:NSMakeRange(3,2)];
//    
//    NSString *dateStr = [NSString stringWithFormat:NSLocalizedString(@"昨日收益(%d月%d日)", nil),[monthStr intValue],[dayStr intValue]];
//    ChainBusinessStatisticsDay *day =[ChainBusinessStatisticsDay convertShopDetail:yestordayDic];
//    //营业汇总模块是否显示
//    if(day) {
//        self.bussinessPanel.hidden = NO;
//        _businessPanelHeight = businessPanelHeight + 4;
//        
//    }else {
//        self.bussinessPanel.hidden = YES;
//        _businessPanelHeight = 0;
//    }
//    [self updateHeaderView];
//    
//    NSArray *businessSummaryArray;
//    if (!day) {
//        businessSummaryArray = @[@"0",@"0",@"0",@"0",@"0",@"0"];
//    } else {
//        
//        businessSummaryArray = @[[self formatNumber:day.sourceAmount],
//                                 [self formatNumber:day.discountAmount],
//                                 [self formatNumber:day.profitLossAmount],
//                                 [self formatInt:(int)day.orderCount unit:NSLocalizedString(@"张", nil)],
//                                 [self formatInt:(int)day.mealsCount unit:NSLocalizedString(@"人", nil)],
//                                 [self formatNumber:day.actualAmountAvg]];
//    }
//    NSString *totalAmout;
//    if ([NumberUtil isNotZero:day.actualAmount]) {
//        totalAmout = [FormatUtil formatDoubleWithSeperator:day.actualAmount];
//    }else{
//        totalAmout = @"-";
//    }
//    
//    [self.bussinessPanel initDataWithDateYesterDay:yestodayStr
//                                     andYesterDate:dateStr
//                                     andTotalAmout:totalAmout
//                                          withData:businessSummaryArray];
//    
//}
///选店
- (void)dealWithShopList:(BOOL)hasOtherEntity {
    if (hasOtherEntity) {
        [self.centenImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@22);
        }];
        self.centerControl.userInteractionEnabled = YES;
    } else {
        [self.centenImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        self.centerControl.userInteractionEnabled = NO;
    }
}
///通知
- (void)dealWithFindNotice:(NSDictionary *)findNoticeResultVo
{
    if (!findNoticeResultVo) {
        self.systemNotePanel.hidden = YES;
//        CGRect oriFrame = self.bussinessPanel.frame;
//        oriFrame.origin.y = padding;
//        self.bussinessPanel.frame = oriFrame;
        _systemNotePanelHeight = 0;
        [self updateHeaderView];
        return;
    }
    self.systemNotePanel.hidden = NO;
//    CGRect oriFrame = self.bussinessPanel.frame;
//    oriFrame.origin.y = 47;
//    self.bussinessPanel.frame = oriFrame;
    _systemNotePanelHeight = systemNotePanelHeight + 8;
    [self updateHeaderView];
    NSDictionary *sysNotificationDic = findNoticeResultVo[@"sysNotification"];
    NSUInteger sysNotificationCount = [findNoticeResultVo[@"sysNotificationCount"] integerValue];
    SysNotification *sysNotification = [SysNotification convertToSysNotification:sysNotificationDic];
    id  content = [[NSUserDefaults standardUserDefaults] objectForKey:@"TDFSystemNotifications"];
    BOOL isRead = NO;
    
    if (!sysNotification || !sysNotification._id) {
        isRead = YES;
    }
    
    NSDictionary *notiDict = content [@"data"];
    NSArray *list = [notiDict objectForKey:@"sysNotificationVos"];
    NSMutableArray *notificationList=[SysNotification convertToSysNotificationsByArr:list];
    for (SysNotification *notification in notificationList) {
        if ([notification._id isEqualToString:sysNotification._id]) {
            isRead = YES;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(isRead) forKey:@"isNotificationRead"];
    

    [self.systemNotePanel initWithData:sysNotification count:sysNotificationCount];
    [self refreshSysNotification:sysNotificationCount];
}

- (void)refreshSysNotification:(NSUInteger)sysNotificationCount
{
    UINavigationController *naviViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSArray *viewControllers = nil;
    if ([naviViewController isKindOfClass:[UINavigationController class]]) {
        viewControllers = naviViewController.viewControllers;
    }
    for (UIViewController *viewController in viewControllers) {
        if ([viewController isKindOfClass:[MainUnit class]]) {
            MainUnit *main = (MainUnit *)viewController;
            [main.otherMenu refreshSysStatus:sysNotificationCount];
            break;
        }
    }
    
    NSNumber *isRead = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNotificationRead"];
    
    self.icoSysNotification.hidden = [isRead boolValue];
//    [self changeNotiLabelWithCount:sysNotificationCount];
}

- (void)refreshNote
{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSArray *viewControllers ;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewControllers = [(UINavigationController *)viewController viewControllers];
    }else if ([viewController isKindOfClass:[UIViewController class]]) {
        viewControllers = viewController.navigationController.viewControllers;
    }
    for (UIViewController *viewController in viewControllers) {
        if ([viewController isKindOfClass:[MainUnit class]]) {
            MainUnit *main = (MainUnit *)viewController;
            [main.otherMenu refreshSysStatus:0];
            break;
        }
    }
    self.icoSysNotification.hidden = YES;
    self.systemNotePanel.igvNew.hidden = YES;
}

//- (void)changeNotiLabelWithCount:(NSInteger)count
//{
//    if (count > 0 && count < 10) {
////        self.lblNoteNum.text = [NSString stringWithFormat:@"%li", (long)count];
//        self.icoSysNotification.image = [UIImage imageNamed:@"notiNumIconOne.png"];
//        
//        [self.icoSysNotification mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(12));
//        }];
//    } else if (count >= 10 && count <= 99) {
////        self.lblNoteNum.text = [NSString stringWithFormat:@"%li", (long)count];
//        self.icoSysNotification.image = [UIImage imageNamed:@"notiNumIconTwo.png"];
//        [self.icoSysNotification mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(16));
//        }];
//    } else if (count > 99) {
////        self.lblNoteNum.text = @"99+";
//        self.icoSysNotification.image = [UIImage imageNamed:@"notiNumIconThree.png"];
//        [self.icoSysNotification mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(20));
//        }];
//    }
//}

#pragma mark --updateHeaderView
- (void)updateHeaderView
{
    self.reuseableViewHeight = 40 + _systemNotePanelHeight + self.businessViewHeight;
    self.headerInfoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.reuseableViewHeight - sectionHeaderHeight);
}
#pragma mark --点击事件
- (void)selectShop
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(selectShop)]) {
        [self.delegate selectShop];
    }
}

- (void)leftButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftButtonClick)]) {
        [self.delegate leftButtonClick];
    }
}

- (void)rightButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightButtonClick)]) {
        [self.delegate rightButtonClick];
    }
}
#pragma mark -- IEventListener
- (void)onEvent:(NSString *)eventType object:(id)object
{
    if ([REFRESH_SYS_NOTIFICAION isEqualToString:eventType]) {
        SysNotificationVO *sysNotificationVo = (SysNotificationVO *)object;
        SysNotification *sysNotification = [[SysNotification alloc] init];
        if (sysNotificationVo.title.length == 0) {
            return;
        }
        sysNotification.name = sysNotificationVo.title;
        [self.systemNotePanel initWithData:sysNotification count:sysNotificationVo.count];
    }
}
#pragma mark --TDFBusinessDetailPanelViewDelegate
- (void)touchUpClick
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(showBusinessDetail)]) {
        [self.delegate showBusinessDetail];
    }
}

- (NSString *)formatNumber:(double)value
{
    if ([NumberUtil isNotZero:value]) {
        return [FormatUtil formatDoubleWithSeperator:value];
    }
    return @"0";
}

- (NSString *)formatInt:(int)value unit:(NSString*)unit
{
    if ([NumberUtil isNotZero:value]) {
        return [FormatUtil formatIntWithSeperator:value];
    }
    return @"0";
}

#pragma mark --界面初始化
#pragma mark --init

#pragma mark - layout
- (void)layoutHeaderInfoView
{
    [self.systemNotePanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerInfoView.mas_top).offset(padding);
        make.left.equalTo(self.headerInfoView.mas_left);
        make.right.equalTo(self.headerInfoView.mas_right);
        make.height.equalTo(@35);
    }];
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    }
    return _headerView;
}


- (UICollectionView *)collectView
{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellWidth, cellHeight);
        layout.sectionInset = UIEdgeInsetsMake(cellTopPadding, cellLeftRightPadding, cellTopPadding, cellLeftRightPadding);
        layout.minimumLineSpacing = cellTopPadding;
        layout.minimumInteritemSpacing = cellTopPadding;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.frame.size.height - 64) collectionViewLayout:layout];
    }
    return _collectView;
}
- (SystemNotePanel *)systemNotePanel
{
    if (!_systemNotePanel) {
        _systemNotePanel = [[SystemNotePanel alloc] init];
    }
    return _systemNotePanel;
}


//- (TDFBusinessDetailPanelView *)bussinessPanel
//{
//    if (!_bussinessPanel) {
//        _bussinessPanel = [[TDFBusinessDetailPanelView alloc] initWithFrame:CGRectMake(5, 47, SCREEN_WIDTH - 10, businessPanelHeight)];
//        [self initBussinessPanel];
//    }
//    return _bussinessPanel;
//}

- (void)initHeaderView
{
    [self addSubview:self.headerView];
    _leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.hidden = ![[Platform Instance] isBranch];
    _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_setup.png"]];
    self.icoSysNotification = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notiNumIconOne.png"]];
//    self.lblNoteNum = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.lblNoteNum.font = [UIFont systemFontOfSize:10];
//    self.lblNoteNum.textAlignment = NSTextAlignmentCenter;
//    self.lblNoteNum.textColor = [UIColor whiteColor];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_user.png"]];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.centenImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_more_down.png"]];
    self.centenImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.centerControl = [[UIControl alloc] init];
    [self.centerControl addTarget:self action:@selector(selectShop) forControlEvents:UIControlEventTouchUpInside];
//    [self.icoSysNotification addSubview:self.lblNoteNum];
    [self.centerControl addSubview:self.titleLabel];
    [self.centerControl addSubview:self.centenImageView];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.headerView addSubview:self.centerControl];
    [self.headerView addSubview:line];
    [self.headerView addSubview:_leftButton];
    [self.headerView addSubview:self.centerControl];
    [self.headerView addSubview:rightButton];
    [self.headerView addSubview:_leftImageView];
    [self.headerView addSubview:rightImageView];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left).offset(5);
        make.right.equalTo(self.headerView.mas_right).offset(-5);
        make.bottom.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left).offset(10);
        make.centerY.equalTo(self.headerView.mas_centerY).offset(10);
    }];
    [self.centerControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView.mas_centerX);
        make.centerY.equalTo(self.headerView.mas_centerY).offset(10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerControl.mas_centerY);
        make.left.equalTo(self.centerControl.mas_left);
        make.top.equalTo(self.centerControl.mas_top);
        make.bottom.equalTo(self.centerControl.mas_bottom);
        make.right.equalTo(self.centenImageView.mas_left);
    }];
    [self.centenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerControl.mas_centerY);
        make.right.equalTo(self.centerControl.mas_right);
        make.top.equalTo(self.centerControl.mas_top);
        make.bottom.equalTo(self.centerControl.mas_bottom);
        make.height.equalTo(@22);
        make.width.equalTo(@22);
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView.mas_right).offset(-10);
        make.centerY.equalTo(self.headerView.mas_centerY).offset(10);
    }];
    
//    [self.lblNoteNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.icoSysNotification);
//    }];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftButton.mas_centerY);
        make.left.equalTo(_leftButton.mas_left);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightButton.mas_centerY);
        make.right.equalTo(rightButton.mas_right);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    [self.headerView addSubview:self.icoSysNotification];
    [self.icoSysNotification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImageView.mas_trailing).with.offset(-3);
        make.centerY.equalTo(rightImageView.mas_top).with.offset(3);
        make.width.equalTo(@8);
        make.height.equalTo(@8);
    }];
}

- (void)initCollectionView
{
    [self addSubview:self.collectView];
    self.collectView.backgroundColor = [UIColor clearColor];
    self.collectView.delegate        = self;
    self.collectView.dataSource      = self;

    [self.collectView registerClass:[TDFMainButtonCollectionViewCell class] forCellWithReuseIdentifier:@"TDFMainButtonCollectionViewCell"];
    [self.collectView registerClass:[TDFHomeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TDFHomeCollectionReusableView"];
    [self addRefreshFunction];
}

- (UIView *)businessView
{
    if (!_businessView) {
        _businessView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _businessView;
}


@end
