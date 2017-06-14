//
//  TDFSenderListViewController.m
//  RestApp
//
//  Created by chaiweiwei on 2017/3/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSenderListViewController.h"
#import "TDFRootViewController+FooterButton.h"
#import "AlertBox.h"
#import "TDFMediator+KabawModule.h"
#import "DeliveryMan.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "HelpDialog.h"
#import "Masonry.h"

@interface TDFSenderTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *mobileLabel;

@end

@implementation TDFSenderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *view =[[UIView alloc] init];
        view.backgroundColor =[UIColor whiteColor];
        view.alpha =0.6;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top).with.offset(1);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"ico_arrow_right_gray"];
        
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(icon.image.size);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.mobileLabel];
        [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(icon.mas_left).with.offset(-5);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBA(51, 51, 51, 1);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)mobileLabel {
    if(!_mobileLabel) {
        _mobileLabel = [[UILabel alloc] init];
        _mobileLabel.textColor = RGBA(102, 102, 102, 1);
        _mobileLabel.font = [UIFont systemFontOfSize:15];
    }
    return _mobileLabel;
}

@end

@interface TDFSenderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TDFSenderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"送货人", nil);
    self.datas = self.params[@"data"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadDatas];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd | TDFFooterButtonTypeHelp];
    
}

#pragma mark mark tableviewHeader
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque=NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 76, 0);
        
        [_tableView registerClass:[TDFSenderTableViewCell class] forCellReuseIdentifier:@"TDFSenderTableViewCell"];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryMan *editObj=self.datas[indexPath.row];
    TDFSenderTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"TDFSenderTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = editObj.name;
    cell.mobileLabel.text = [NSString stringWithFormat:@"%@ %@",editObj.countryCode,editObj.phone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeliveryMan* editObj=self.datas[indexPath.row];
    UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_senderEditViewControllerWithData:editObj action:ACTION_CONSTANTS_EDIT CallBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 数据加载
-(void)loadDatas
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[ServiceFactory Instance].kabawService listSenderTarget:self Callback:@selector(loadFinish:)];
}

-(void) loadFinish:(RemoteResult*) result{
    
    [self.progressHud setHidden:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }

    NSDictionary* map=[JsonHelper transMap:result.content];
    NSArray *list = [map objectForKey:@"data"];
    self.datas=[JsonHelper transList:list objName:@"DeliveryMan"];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_SENDER_REFRESH object:self.datas];
}

-(void) footerAddButtonAction:(UIButton *)sender
{
    UIViewController *viewController=[[TDFMediator sharedInstance]TDFMediator_senderEditViewControllerWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^{
        [self loadDatas];
    }];
    [self.navigationController  pushViewController:viewController animated:YES];
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"outsale"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:NSLocalizedString(@" ", nil)];
}
@end
