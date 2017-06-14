//
//  TDFOtherMenuViewController.m
//  RestApp
//
//  Created by 刘红琳 on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "User.h"
#import "Platform.h"
#import "AboutView.h"
#import "SystemUtil.h"
#import "SystemEvent.h"
#import "ViewFactory.h"
#import "BaseService.h"
#import "FeedBackView.h"
#import "UserInfoView.h"
#import "AppController.h"
#import "INavigateEvent.h"
#import "IEventListener.h"
#import "EventConstants.h"
#import "BackgroundView.h"
#import "View+MASAdditions.h"
#import "NSString+Estimate.h"
#import "SysNotificationVO.h"
#import "SysNotificationView.h"
#import "UIImageView+WebCache.h"
#import "TDFMediator+UserAuth.h"
#import "TDFBarcodeViewController.h"
#import "TDFOtherMenuViewController.h"
#import "TDFMediator+ShopManagerModule.h"
#import "TDFMediator+AccountRechargeModule.h"
#import "TDFRootViewController+MemberModule.h"
#import <TDFNetworkEnvironmentSwitcher/TDFNetworkEnvironmentController.h>
#import "TDFSobotChat.h"

static TDFOtherMenuViewController *instance;
@interface TDFOtherMenuViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,IEventListener>

@property (nonatomic,strong) UINavigationController *rootController;
@property (nonatomic, strong)UINavigationController *rootViewController;
@property (nonatomic, strong)  UILabel *lblUser;  //用户
@property (nonatomic, strong)  UILabel *lblNote;  //角标
@property (nonatomic, strong)  UILabel *lblCompany;  //公司
@property (nonatomic, strong)  UIImageView *imgUser;  //头像
@property (nonatomic, strong)  UIImageView *imgNote;  //角标
@property (nonatomic, strong)  UIScrollView *scrollView;  //角标
@property (nonatomic, strong) UITableView *mainGird;
@property (nonatomic, strong) UILabel *firstLine;
@property (nonatomic, strong) UIView *header;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imgArray;
@end

@implementation TDFOtherMenuViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
#if DEBUG
    UIButton *changeEnvironmentButton = [self.view viewWithTag:1005];
    TDFNetworkEnvironmentController *environmentController = [TDFNetworkEnvironmentController sharedInstance];
    TDFNetworkEnvironmentModel *model = environmentController.currentEnvironment;
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"%@环境", nil), model.evnironmentName];
    [changeEnvironmentButton setTitle:title forState:UIControlStateNormal];
#endif
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    [self refreshSysStatus:100];
}

- (void) loadData{
    if (![[Platform Instance] isBranch]) {
        self.titleArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"我工作的店家", nil),NSLocalizedString(@"点券账户", nil),NSLocalizedString(@"系统通知", nil) ,NSLocalizedString(@"扫一扫", nil),NSLocalizedString(@"更换背景图", nil),NSLocalizedString(@"意见反馈", nil),NSLocalizedString(@"关于", nil),NSLocalizedString(@"退出登录", nil),nil];
        self.imgArray = [NSMutableArray arrayWithObjects:@"ico_more_shop.png",@"accountRecharge",@"ico_more_msg.png" ,@"scanQRcode.png",@"ico_more_bg.png",@"ico_more_contact.png",@"ico_more_about.png",@"ico_more_quit.png", nil];
    }else{
        self.titleArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"我工作的店家", nil),NSLocalizedString(@"系统通知", nil) ,NSLocalizedString(@"扫一扫", nil),NSLocalizedString(@"更换背景图", nil),NSLocalizedString(@"意见反馈", nil),NSLocalizedString(@"关于", nil),NSLocalizedString(@"退出登录", nil),nil];
        self.imgArray = [NSMutableArray arrayWithObjects:@"ico_more_shop.png",@"ico_more_msg.png" ,@"scanQRcode.png",@"ico_more_bg.png",@"ico_more_contact.png",@"ico_more_about.png",@"ico_more_quit.png", nil];
    }
    [self.mainGird reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    instance = self;
    
    [self initNotification];
    [self initMainView];
}

#pragma 通知
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInfoChanged:) name:Notification_UserInfo_Change object:nil];
}

-(void)loadFinsh:(NSNotification *) notification
{
    NSDictionary* dic = notification.object;
    self.username = dic[@"showName"];
    self.roleName = dic[@"roleName"];
    self.server = dic[@"server"];
    self.path = dic[@"path"];
    [self refreshUI];
}
- (void)userInfoChanged:(NSNotification *)notification
{
    [self refreshUI];
}

#pragma UI布局
- (void) initMainView
{
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"bg_00.png"];
    [self.view addSubview:self.mainGird];
}

- (void) refreshUI
{
    NSString *nickName, *imageUrl;
    nickName = [Platform Instance].memberExtend.userName;
    imageUrl =[Platform Instance].memberExtend.url;
    NSString *roleName = [Platform Instance].memberExtend.roleName;
    NSString *shopName = [Platform Instance].memberExtend.shopName;
    
    NSString *company = @"";
    if ([NSString isNotBlank:shopName] && [NSString isNotBlank:roleName]) {
        company = [NSString stringWithFormat:@"%@, %@", shopName, roleName];
    }
    self.lblUser.text = nickName;
    self.lblCompany.text = company;
    [self.imgUser sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"img_nopic_user.png"]];
}

#if DEBUG
- (void)changeEnvironmentButtonAction:(id)sender {
    TDFNetworkEnvironmentController *environmentController = [TDFNetworkEnvironmentController sharedInstance];
    [environmentController switchEnvironmentWithHostViewController:self.rootController];
}

#endif

#pragma set---get----
- (UITableView *) mainGird
{
    if (!_mainGird) {
        self.mainGird = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*1/3, 0, SCREEN_WIDTH - (SCREEN_WIDTH*1/3), SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.mainGird.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7 ];
        self.mainGird.delegate = self;
        self.mainGird.dataSource = self;
        self.mainGird.opaque = NO;
        self.mainGird.tableFooterView = [ViewFactory generateFooter:60];
        self.mainGird.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return _mainGird;
}

+ (TDFOtherMenuViewController *)sharedInstance
{
    return instance;
}

- (UINavigationController *)rootViewController{
    if (!_rootViewController) {
        if (self.navigationController) {
            _rootViewController = self.navigationController;
        }else
        {
            _rootViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        }
    }
    return _rootViewController;
}

- (UINavigationController *)rootController
{
    if (!_rootController) {
        UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            _rootController = (UINavigationController *)viewController;
        }else if ([viewController isKindOfClass:[UIViewController class]])
        {
            _rootController = viewController.navigationController;
        }
    }
    return _rootController;
}

- (UIImageView*)imgUser
{
    if (!_imgUser) {
        _imgUser = [[UIImageView alloc] init];
        [_imgUser.layer setMasksToBounds:YES];
        [_imgUser.layer setCornerRadius:36];
        [_imgUser.layer setBorderWidth:1];
        [_imgUser.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return _imgUser;
}

- (UILabel *)lblUser
{
    if (!_lblUser) {
        self.lblUser = [[UILabel alloc] init];
        self.lblUser.textAlignment = NSTextAlignmentCenter;
        self.lblUser.font = [UIFont boldSystemFontOfSize:17];
    }
    return _lblUser;
}

- (UILabel *)lblCompany
{
    if (!_lblCompany) {
        self.lblCompany = [[UILabel alloc] init];
        self.lblCompany.textAlignment = NSTextAlignmentCenter;
        self.lblCompany.font = [UIFont systemFontOfSize:11];
    }
    return _lblCompany;
}

- (UIView *)header
{
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2/3, 180)];
        [_header addSubview:self.imgUser];
        [self.imgUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_header.mas_centerX).offset(0);
            make.top.equalTo(_header.mas_top).with.offset(50);
            make.size.mas_equalTo (CGSizeMake(72, 72));
        }];
        
        [_header addSubview:self.lblUser];
        [self.lblUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_header.mas_left).offset(0);
            make.top.equalTo(_header.mas_top).with.offset(140);
            make.right.equalTo(_header.mas_right).offset(0);
            make.height.equalTo(@21);
        }];
        
        UIImageView *icoUserRight = [[UIImageView alloc] init];
        [_header addSubview:icoUserRight];
        icoUserRight.image = [UIImage imageNamed:@"ico_next_w.png"];
        [icoUserRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgUser.mas_right).offset(0);
            make.centerY.equalTo(self.imgUser.mas_centerY).offset(0);
            make.size.mas_equalTo (CGSizeMake(35, 35));
        }];
        
        [_header addSubview:self.lblCompany];
        [self.lblCompany mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_header.mas_left).offset(0);
            make.top.equalTo(self.lblUser.mas_bottom).offset(0);
            make.right.equalTo(_header.mas_right).offset(0);
            make.height.equalTo(@20);
        }];
        
        if (!self.firstLine) {
            self.firstLine = [[UILabel alloc] init];
            [_header addSubview:self.firstLine];
            self.firstLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
            [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_header.mas_left).offset(10);
                make.top.equalTo(_header.mas_top).with.offset(179);
                make.size.mas_equalTo (CGSizeMake(SCREEN_WIDTH, 1));
            }];
        }
    }
    return _header;
}

- (void)resetShopInfo
{
    self.lblCompany.text = @"";
}

- (void)resetDataView
{
    self.lblUser.text = @"";
    self.lblCompany.text = @"";
    [self.imgUser setImage:[UIImage imageNamed:@"img_nopic_user.png"]];
}

#pragma tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count == 0?1:self.titleArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier: SimpleTableIdentifier];
        if (indexPath.row != 0) {
            UILabel *line = [[UILabel alloc] init];
            [cell.contentView addSubview:line];
            line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(10);
                make.top.equalTo(cell.contentView).with.offset(47);
                make.size.mas_equalTo (CGSizeMake(SCREEN_WIDTH - 70, 1));
            }];
        }
    }
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.header];
#if DEBUG
        UIButton *changeEnvironmentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        changeEnvironmentButton.tag = 1005;
        
        [changeEnvironmentButton addTarget:self action:@selector(changeEnvironmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:changeEnvironmentButton];
        
        //    @weakify(self);
        [changeEnvironmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            //        @strongify(self);
            make.left.equalTo(cell.contentView.mas_left).with.offset(60.0f);
            make.top.equalTo(cell.contentView.mas_top).with.offset(20.0f);
            make.width.mas_equalTo(80.0f);
            make.height.mas_equalTo(30.0f);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLogout) name:kTDFNetworkDidSwitchEnvironmentNotification object:nil];
#endif
        [self refreshUI];
    }else{
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(12);
            make.top.equalTo(cell.contentView.mas_top).offset(8);
            make.size.mas_equalTo (CGSizeMake(32, 32));
        }];
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.imageView.mas_right).offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.size.mas_equalTo (CGSizeMake(100, 21));
        }];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        if ([[Platform Instance] isBranch]) {
            if (indexPath.row == 2) {
                [self.imgNote removeFromSuperview];
                [self.lblNote removeFromSuperview];
                [self creatNote];
                [cell.contentView addSubview:self.imgNote];
                [cell.contentView addSubview:self.lblNote];
            }
        }else{
            if (indexPath.row == 3) {
                [self.imgNote removeFromSuperview];
                [self.lblNote removeFromSuperview];
                [self creatNote];
                [cell.contentView addSubview:self.imgNote];
                [cell.contentView addSubview:self.lblNote];
            }
        }
        cell.textLabel.text = self.titleArray[indexPath.row-1];
        cell.imageView.image = [UIImage imageNamed:self.imgArray[indexPath.row-1]];
        [self refreshSysStatus:self.sysNotificationCount];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)creatNote{
    self.imgNote = [[UIImageView alloc] initWithFrame:CGRectMake(260 -146, 2, 20, 20)];
    self.imgNote.image = [UIImage imageNamed:@"notiNumIconOne.png"];
    
    self.lblNote = [[UILabel alloc] init];
    self.lblNote.textAlignment = NSTextAlignmentCenter;
    self.lblNote.font = [UIFont systemFontOfSize:15];
    self.lblNote.textColor = [UIColor whiteColor];
    [SystemEvent registe:REFRESH_SYS_NOTIFICAION target:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self btnUserInfo];
            break;
        case 1:
            [self btnWorkShop];
            break;
        case 2:
            [[Platform Instance] isBranch]?[self btnSysNotification]:[self btnShowAccountRechargeClick];
            break;
        case 3:
            [[Platform Instance] isBranch]?[self btnQRcodeClicked]:[self btnSysNotification];
            break;
        case 4:
            [[Platform Instance] isBranch]?[self btnChageBg]:[self btnQRcodeClicked];
            break;
        case 5:
            [[Platform Instance] isBranch]?[self btnMail]:[self btnChageBg];
            break;
        case 6:
            [[Platform Instance] isBranch]?[self btnAbout]:[self btnMail];
            break;
        case 7:
            [[Platform Instance] isBranch]?[self btnExit]:[self btnAbout];
            break;
        case 8:
            [self btnExit];
        default:
            break;
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 180;
    }
    return 48;
}

#pragma indexPathRowSelect
- (void)btnUserInfo
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_UserInfoViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)btnWorkShop
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopListViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)btnSysNotification
{
    SysNotificationView *syst = [[SysNotificationView alloc]init];
    [syst initDataView];
    [self.rootViewController presentViewController:syst animated:YES completion:nil];
}

- (void)btnChageBg
{
    [self.rootViewController presentViewController:[[BackgroundView alloc]init] animated:YES completion:nil];
    
}

- (void)btnMail
{
    [self.rootViewController presentViewController:[[FeedBackView alloc]init] animated:YES completion:nil];
}

- (void)btnAbout
{
    AboutView *aboutView= [[AboutView alloc]init];
    [self.rootViewController presentViewController:aboutView animated:YES completion:nil];
}

- (void)btnExit
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"确认要退出吗？退出登录不会删除任何数据,重新登录后可继续使用.", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self doLogout];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag==1) {
            [self doLogout];
        } else if (alertView.tag==2) {
            [self doSendMail];
        }
    }
}

- (void)doSendMail
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@2dfire.com"]];
}

- (void)doLogout
{
    [[TDFSobotChat shareInstance] removeCurrentAccount];
    [[AppController shareInstance] startLogout];
}

- (void)btnShowMainClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_MAIN_SHOW_NOTIFICATION object:nil] ;
}

- (void)btnShowAccountRechargeClick {
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TDFMainAccountRechgeViewController];
    [self.rootViewController pushViewController:viewController animated:YES];
}

- (void)btnQRcodeClicked{
    TDFBarcodeViewController *bvc = [[TDFBarcodeViewController alloc]init];
    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:bvc animated:YES];
}

#pragma IEventListener delegate
- (void)onEvent:(NSString *)eventType
{
    
}

- (void)onEvent:(NSString *)eventType object:(id)object
{
    if ([REFRESH_SYS_NOTIFICAION isEqualToString:eventType]) {
        SysNotificationVO *sysNotification = (SysNotificationVO *)object;
        self.imgNote.hidden = NO;
        self.lblNote.hidden = NO;
        [self changeNotiLabelWithCount:sysNotification.count];
    }
}

- (void)changeNotiLabelWithCount:(NSInteger)count
{
    if (count > 0 && count < 10) {
        self.lblNote.text = [NSString stringWithFormat:@"%li", (long)count];
        self.imgNote.image = [UIImage imageNamed:@"notiNumIconOne.png"];
        self.lblNote.frame = CGRectMake(177, 2, 20, 20);
        self.lblNote.center = self.imgNote.center;
    } else if (count >= 10 && count <= 99) {
        self.lblNote.text = [NSString stringWithFormat:@"%li", (long)count];
        self.imgNote.image = [UIImage imageNamed:@"notiNumIconTwo.png"];
        self.lblNote.frame = CGRectMake(177, 2, 26, 20);
        self.lblNote.center = self.imgNote.center;
    } else if (count > 99) {
        self.lblNote.text = @"99+";
        self.imgNote.image = [UIImage imageNamed:@"notiNumIconThree.png"];
        self.lblNote.frame = CGRectMake(177, 32, 26, 20);
        self.lblNote.center = self.imgNote.center;
    }
}

- (void)refreshSysStatus:(NSUInteger)sysNoteCount
{
    self.sysNotificationCount = sysNoteCount;
    NSNumber *isRead = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNotificationRead"];
    
    if (self.sysNotificationCount > 0 && ![isRead boolValue]) {
        self.imgNote.hidden = NO;
        self.lblNote.hidden = NO;
        [self changeNotiLabelWithCount:self.sysNotificationCount];
        
    } else {
        self.imgNote.hidden = YES;
        self.lblNote.hidden = YES;
    }
}

@end
