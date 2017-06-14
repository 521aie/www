//
//  TDFEmployeeEditViewController.m
//  RestApp
//
//  Created by 刘红琳 on 2016/12/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFEmployeeEditViewController.h"
#import "TDFPAShowManagerStrategy.h"
#import "UIImageView+WebCache.h"
#import "TDFCustomStrategy.h"
#import "Platform.h"
#import "JsonHelper.h"
#import "ColorHelper.h"
#import "ImageUtils.h"
#import "FormatUtil.h"
#import "GlobalRender.h"
#import "RestConstants.h"
#import "ImageCropView.h"
#import "PinyinUtils.h"
#import "ObjectUtil.h"
#import "MessageBox.h"
#import "Role.h"
#import "TDFUserService.h"


@interface TDFEmployeeEditViewController()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MessageBoxClient>
{
    NSString *confirmPwd;
    UIImagePickerController *imagePickerController;
}
@property (nonatomic,strong) NSMutableArray *sexList;
@property (nonatomic,strong) UIView *sectionFooterView;
@property (nonatomic, assign) NSInteger imgCurrTag;     //当前的图形控件是那个.
@property (nonatomic, strong) UIImage* imgSelf;
@property (nonatomic, strong) NSString* imgFilePathTemp;
@end

@implementation TDFEmployeeEditViewController

- (void)viewDidLoad {
    [self.manager removeAllSections];
    [super viewDidLoad];
    NSMutableArray *roles = [[NSMutableArray alloc] init];
    for (Role* role in self.roleList) {
        if(![@"0" isEqualToString:role._id]){
            [roles addObject:role];
        }
    }
    self.roleList = roles;
    
    self.userTemp = [[UserVO alloc] init];
    self.employee = [[EmployeeUserVo alloc] init];
    self.employeeVo = [[Employee alloc] init];
    [self configureManager];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =[UIColor whiteColor];
    view.alpha = 0.7;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.employeeType == TDFEmployeeAdd) {
        self.title = NSLocalizedString(@"添加员工", nil);
        [self configNavigationBar:YES];
        [self addBaseSettingSection];
        [self addAccountInfoSection];
        [self addIdentifierInfoSection];
        [self.manager reloadData];
    }
}

- (void)configureManager
{
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    [self.manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
    [self.manager registerCell:@"TDFStaticLabelCell" withItem:@"TDFStaticLabelItem"];
    [self.manager registerCell:@"TDFCardBgImageCell" withItem:@"TDFCardBgImageItem"];
    [self.manager registerCell:@"TDFLabelCell" withItem:@"TDFLabelItem"];
    [self.manager registerCell:@"TDFAvatarImageCell" withItem:@"TDFAvatarImageItem"];
    [self.manager registerCell:@"TDFCardBgImageCell" withItem:@"TDFCardBgImageItem"];
}

- (void)addBaseSettingSection {
    if (self.employeeType == TDFEmployeeEdit) {
        [self.manager addSection:self.headSetion];
    }

    DHTTableViewSection *baseSettingSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"基本设置", nil)];
    
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    [section addItem:self.nameImageItem];
    
    [section addItem:self.roleItem];
    
    [section addItem:self.nameItemText];
    
    [section addItem:self.sexItem];

    [section addItem:self.phoneItem];
    
    [self.manager addSection:baseSettingSection];
    [self.manager addSection:section];
    
}

- (void)addAccountInfoSection {
    DHTTableViewSection *addAccountInfoSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"账户密码信息", nil)];
    DHTTableViewSection *section = [DHTTableViewSection section];
    [section addItem:self.nameItem];
    
    if (self.employeeType == TDFEmployeeAdd) {
        TDFTextfieldItem *pwdItem = [[TDFTextfieldItem alloc] init];
        pwdItem.title = NSLocalizedString(@"员工密码", nil);
        pwdItem.filterBlock = ^(NSString *textValue) {
            self.userTemp.pwd = textValue;
            return YES;
        };
        [section addItem:pwdItem];
        
        TDFTextfieldItem *pwdConfirmItem = [[TDFTextfieldItem alloc] init];
        pwdConfirmItem.title = NSLocalizedString(@"员工密码确认", nil);
        pwdConfirmItem.filterBlock = ^(NSString *textValue) {
            confirmPwd = textValue;
            return YES;
        };
        [section addItem:pwdConfirmItem];
    }else{
        if (self.employee.userVo.isSupper == 1) {
            TDFTextfieldItem *lblNameItem = [[TDFTextfieldItem alloc] init];
            lblNameItem.title = NSLocalizedString(@"员工账号", nil);
            lblNameItem.textValue = self.employee.userVo.userName;
            lblNameItem.preValue = self.employee.userVo.userName;
            lblNameItem.editStyle = TDFEditStyleUnEditable;
            [section addItem:lblNameItem];
        }else{
            
        }
        TDFPickerItem *changePwdItem = [[TDFPickerItem alloc] init];
        changePwdItem.title = NSLocalizedString(@"修改员工密码 ", nil);
        changePwdItem.isRequired = NO;
        TDFCustomStrategy *notIncludeStrategy = [[TDFCustomStrategy alloc] init];
        @weakify(self);
        notIncludeStrategy.btnClickedBlock = ^ () {
            @strongify(self);
            TDFMediator *mediator = [[TDFMediator alloc] init];
            UIViewController *viewController = [mediator TDFMediator_chainEditPassViewControllerWithUser:self.employee.userVo employee:self.employee.employeeVo];
            [self.navigationController pushViewController:viewController animated:YES];
            [self.manager reloadData];
        };
          [section addItem:changePwdItem];
        changePwdItem.strategy = notIncludeStrategy;
    }
    [self.manager addSection:addAccountInfoSection];
    [self.manager addSection:section];
    
    DHTTableViewSection *footerSection = [DHTTableViewSection section];
    footerSection.footerView = self.sectionFooterView;
    footerSection.footerHeight = 60;
    [self.manager addSection:footerSection];
}

-(void) addIdentifierInfoSection
{
    DHTTableViewSection *identifierInfoSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"身份证信息", nil)];
    DHTTableViewSection *section = [DHTTableViewSection section];

    [section addItem:self.identifierItem];
    
    TDFCardBgImageItem *imageItem = [[TDFCardBgImageItem alloc] init];
    imageItem.showRightArea = NO;
    imageItem.title = NSLocalizedString(@"身份证图片", nil);
    imageItem.showDelButton = YES;
    imageItem.imageContentMode = UIViewContentModeScaleAspectFit;
    @weakify(self);
    imageItem.filterBlock = ^(NSInteger idx,TDFFilterType filterType){
        if (idx == 0) {
            if (filterType == TDFFilterTypeAdd) {
                @strongify(self);
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择图片来源", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"图库", nil),NSLocalizedString(@"拍照", nil), nil];
                sheet.tag=2;
                [sheet showInView:[UIApplication sharedApplication].keyWindow];
            }else if (filterType == TDFFilterTypeDel)
            {
                [self showDeleteMessageWithImage:idx];
            }
        }else if (idx == 1)
        {
            if (filterType == TDFFilterTypeAdd) {
                @strongify(self);
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择图片来源", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"图库", nil),NSLocalizedString(@"拍照", nil), nil];
                sheet.tag=3;
                [sheet showInView:[UIApplication sharedApplication].keyWindow];
            }else if (filterType == TDFFilterTypeDel)
            {
                [self showDeleteMessageWithImage:1];
            }
        }
    };
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:self.frontItem];
    [arr addObject:self.backItem];
    
    imageItem.cardImageItems = arr;
    [section addItem:imageItem];
    
    [self.manager addSection:identifierInfoSection];
    [self.manager addSection:section];
    
    DHTTableViewSection *footerSection = [DHTTableViewSection section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footerSection.footerView = view;
    footerSection.footerHeight = 10;
    [self.manager addSection:footerSection];
}

- (void)showDeleteMessageWithImage:(NSInteger) index
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您确认要删除当前的图片吗？", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            if (index == 0) {
                                                                self.frontItem.cardImage = nil;
                                                                self.employeeVo.frontPath = nil;
                                                                self.frontItem.cardImagePath = nil;
                                                                [self.manager reloadData];
                                                            }else if(index == 1){
                                                                self.backItem.cardImage = nil;
                                                                self.employeeVo.backPath = nil;
                                                                self.backItem.cardImagePath = nil;
                                                                [self.manager reloadData];
                                                            }
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             return ;
                                                         }];
    
    [alertController addAction:enterAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- tableviewHeader
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque=NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    }
    return _tableView;
}

- (TDFTextfieldItem *) identifierItem
{
    if (!_identifierItem) {
        _identifierItem = [[TDFTextfieldItem alloc] init];
        _identifierItem.title = NSLocalizedString(@"身份证号", nil);
        _identifierItem.isRequired = NO;
        _identifierItem.textValue = self.employee.employeeVo.idCard;
        _identifierItem.preValue = self.employee.employeeVo.idCard;
        _identifierItem.keyboardType = UIKeyboardTypeNumberPad;
         @weakify(self);
        _identifierItem.filterBlock = ^(NSString *textValue) {
            @strongify(self);
            self.employeeVo.idCard = textValue;
            return YES;
        };
    }
    return _identifierItem;
}

- (TDFPickerItem *) sexItem
{
    if (!_sexItem) {
        __block NameItemVO *item;
        if (self.employeeType == TDFEmployeeAdd) {
            item = self.sexList.firstObject;
        }else{
            NSString* sexStr=[NSString stringWithFormat:@"%d",self.employee.employeeVo.sex==0?1:self.employee.employeeVo.sex];
            item = [[NameItemVO alloc] initWithVal:[GlobalRender obtainItem:[GlobalRender listSexs] itemId:sexStr] andId:sexStr];
        }
        _sexItem = [[TDFPickerItem alloc] init];
        _sexItem.title = NSLocalizedString(@"性别 ", nil);
        _sexItem.textValue = item.itemName;
        _sexItem.preValue = item.itemName;
        
        TDFShowPickerStrategy *sexStrategy = [[TDFShowPickerStrategy alloc] init];
        sexStrategy.pickerName = NSLocalizedString(@"性别", nil);
        sexStrategy.selectedItem = item;
        sexStrategy.pickerItemList = self.sexList;
        _sexItem.strategy = sexStrategy;
        @weakify(self);
        _sexItem.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
            @strongify(self);
            self.employeeVo.sex = [requestValue intValue];
            [self.manager reloadData];
            return YES;
        };
        
    }
    return _sexItem;
}

- (TDFTextfieldItem *) phoneItem
{
    if (!_phoneItem) {
        _phoneItem = [[TDFTextfieldItem alloc] init];
        _phoneItem.title = NSLocalizedString(@"手机号码", nil);
        _phoneItem.isRequired = NO;
        _phoneItem.textValue = self.employee.employeeVo.mobile;
        _phoneItem.preValue = self.employee.employeeVo.mobile;
        _phoneItem.keyboardType = UIKeyboardTypeNumberPad;
        @weakify(self);
        _phoneItem.filterBlock = ^(NSString *textValue) {
            @strongify(self);
            self.employeeVo.mobile = textValue;
            return YES;
        };
    }
    return _phoneItem;
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    return _manager;
}

- (UIView *)sectionFooterView {
    if(!_sectionFooterView) {
        _sectionFooterView = [[UIView alloc] init];
        _sectionFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        label.font = [UIFont systemFontOfSize:11];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 50);
        label.text = NSLocalizedString(@"提示:员工可以使用微信或手机号码登录火掌柜，在“添加工作的店家“时,使用此处的员工用户名和密码，添加完成后即可使用商圈", nil);
        [_sectionFooterView addSubview:label];
    }
    return _sectionFooterView;
}

- (UIView *)tableViewFooterView {
    if(!_tableViewFooterView) {
        _tableViewFooterView = [[UIView alloc] init];
        _tableViewFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        
        UIButton *deletButton = [[UIButton alloc] init];
        [deletButton setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        deletButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [deletButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deletButton.layer.masksToBounds = YES;
        deletButton.layer.cornerRadius = 6;
        [deletButton setBackgroundColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1]];
        deletButton.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 40);
        [deletButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewFooterView addSubview:deletButton];
    }
    return _tableViewFooterView;
}

- (TDFCardBgImageBaseItem *) frontItem
{
    if (!_frontItem) {
        _frontItem = [[TDFCardBgImageBaseItem alloc] init];
        _frontItem.titleForAddImageButton = NSLocalizedString(@"身份证正面图片", nil);
        _frontItem.descTitleValue = NSLocalizedString(@"图片尺寸：不小于400*300px（像素）\n图片格式：jpg、png格式", nil);
        if ([NSString isBlank:self.employee.employeeVo.frontPath] || [self.employee.employeeVo.frontPath isEqualToString:
            @"-1"]) {
            _frontItem.preValue = @"";
            _frontItem.cardImagePath = @"";
        }else{
            _frontItem.cardImagePath = [ImageUtils getImageUrl:self.employee.employeeVo.frontServer path:self.employee.employeeVo.frontPath];
            _frontItem.preValue = [ImageUtils getImageUrl:self.employee.employeeVo.frontServer path:self.employee.employeeVo.frontPath];
        }

    }
    return _frontItem;
}

- (TDFCardBgImageBaseItem *) backItem
{
    if (!_backItem) {
        
        _backItem = [[TDFCardBgImageBaseItem alloc] init];
        _backItem.titleForAddImageButton = NSLocalizedString(@"身份证背面图片", nil);
        _backItem.descTitleValue = NSLocalizedString(@"图片尺寸：不小于400*300px（像素）\n图片格式：jpg、png格式", nil);
        if ([NSString isBlank:self.employee.employeeVo.backPath] ||  [self.employee.employeeVo.backPath isEqualToString:
                                                                      @"-1"]) {
            _backItem.preValue = @"";
            _backItem.cardImagePath = @"";
        }else{
            _backItem.cardImagePath = [ImageUtils getImageUrl:self.employee.employeeVo.backServer path:self.employee.employeeVo.backPath];
            _backItem.preValue = [ImageUtils getImageUrl:self.employee.employeeVo.backServer path:self.employee.employeeVo.backPath];
        }
    }
    return _backItem;
}

- (TDFTextfieldItem *) nameItemText
{
    if (!_nameItemText) {
        _nameItemText = [[TDFTextfieldItem alloc] init];
        _nameItemText.title = NSLocalizedString(@"姓名", nil);
        _nameItemText.textValue = self.employee.employeeVo.name;
        _nameItemText.preValue = self.employee.employeeVo.name;
        @weakify(self);
        _nameItemText.filterBlock = ^(NSString *textValue) {
            @strongify(self);
            self.employeeVo.name = textValue;
            NSString* py=[PinyinUtils convertToPy:textValue];
            self.nameItem.textValue = py;
            self.userTemp.userName = py;
            self.userTemp.username = py;
            if (self.employeeType == TDFEmployeeAdd) {
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                if (![self.employee.userVo.roleId isEqualToString:@"0"]) {
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:4]] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            return YES;
        };
        
    }
    return _nameItemText;
}

- (TDFAvatarImageItem *) nameImageItem
{
    if (!_nameImageItem) {
        _nameImageItem = [[TDFAvatarImageItem alloc] init];
        _nameImageItem.title = NSLocalizedString(@"头像", nil);
        NSString* sexStr=[NSString stringWithFormat:@"%d",self.employee.employeeVo.sex==0?1:self.employee.employeeVo.sex];
        NSString* imgPath=nil;
        if([sexStr isEqualToString:@"1"]){
            imgPath=@"img_stuff_male.png";
        } else {
            imgPath=@"img_stuff_female.png";
        }
        if (self.employee.employeeVo.path == nil) {
            _nameImageItem.defaultFileName = imgPath;
            _nameImageItem.preValue = @"";
            _nameImageItem.filePath = @"";
        }else{
            _nameImageItem.filePath = [ImageUtils getImageUrl:self.employee.employeeVo.server path:self.employee.employeeVo.path];;
            _nameImageItem.preValue = [ImageUtils getImageUrl:self.employee.employeeVo.server path:self.employee.employeeVo.path];;
        }
        
        @weakify(self);
        _nameImageItem.filterBlock = ^(void){
             @strongify(self);
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择图片来源", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"图库", nil),NSLocalizedString(@"拍照", nil), nil];
            sheet.tag=1;
            [sheet showInView:[UIApplication sharedApplication].keyWindow];
        };
    }
    return _nameImageItem;
}

- (UIView *) headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 47, self.view.frame.size.width, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [_headView addSubview:line1];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        [_headView addSubview:view];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 47, self.view.frame.size.width, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_headView addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, self.view.frame.size.width - 20, 26)];
        label.text = NSLocalizedString(@"员工二维火账户资料", nil);
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        
        if (self.memberExtend != nil) {
            UIButton *unBindBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70, 9, 70, 26)];
            [unBindBtn setTitle:NSLocalizedString(@"解除绑定", nil) forState:UIControlStateNormal];
            [unBindBtn setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
            unBindBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [unBindBtn addTarget:self action:@selector(noBindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:unBindBtn];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, 64, 64)];
            [image.layer setMasksToBounds:YES];
            [image.layer setCornerRadius:32];
            [image.layer setBorderWidth:1];
            [image.layer setBorderColor:[UIColor whiteColor].CGColor];
            if ([NSString isNotBlank:self.memberExtend.url]) {
                [image sd_setImageWithURL:[NSURL URLWithString:self.memberExtend.url] placeholderImage:[UIImage imageNamed:@"img_default.png"]];
            } else {
                 [image setImage:[UIImage imageNamed:@"img_default.png"]];
            }
            [_headView addSubview:image];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(84, 64, SCREEN_WIDTH - 64, 26)];
            name.textColor =[UIColor blackColor];
            name.font = [UIFont systemFontOfSize:15];
            name.text = [NSString stringWithFormat:@"%@(%@)",[FormatUtil formatStringLength:self.memberExtend.userName length:8],([@"1" isEqualToString:self.memberExtend.sex]?NSLocalizedString(@"男", nil):NSLocalizedString(@"女", nil))];
            [_headView addSubview:name];
            
            UILabel *mobole = [[UILabel alloc] initWithFrame:CGRectMake(84, 90, SCREEN_WIDTH-84, 26)];
            mobole.textColor =[UIColor blackColor];
            mobole.font = [UIFont systemFontOfSize:15];
            mobole.text = [NSString stringWithFormat:@"手机:  %@ %@",self.memberExtend.countryCode,[self.memberExtend.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
            [_headView addSubview:mobole];
        } else {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, self.view.frame.size.width - 20, 28)];
            label1.textColor =[UIColor redColor];
            label1.font = [UIFont systemFontOfSize:16];
            label1.text = NSLocalizedString(@"员工没有在“我工作的店家”中添加本店", nil);
            [_headView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 92, self.view.frame.size.width - 20, 63)];
            label2.textColor =[UIColor blackColor];
            label2.font = [UIFont systemFontOfSize:13];
            label2.numberOfLines = 0;
            label2.text = NSLocalizedString(@"请联系这个员工，安装“二维火掌柜”应用，登陆后，在“更多”-“我工作的店家”模块中添加本店，就可以开始工作了。", nil);
            [_headView addSubview:label2];
        }
    }
    return _headView;
}

- (TDFTextfieldItem *) nameItem
{
    if (!_nameItem) {
        _nameItem = [[TDFTextfieldItem alloc] init];
        _nameItem.title = NSLocalizedString(@"员工用户名", nil);
        if ([self.employee.userVo.roleId isEqualToString:@"0"]) {
           _nameItem.textValue = NSLocalizedString(@"超级管理员", nil);
            _nameItem.preValue = NSLocalizedString(@"超级管理员", nil);
            _nameItem.editStyle = TDFEditStyleUnEditable;
        }else{
            _nameItem.textValue = self.employee.userVo.userName;
            _nameItem.preValue = self.employee.userVo.userName;
             _nameItem.editStyle = TDFEditStyleEditable;
        }
        @weakify(self);
        _nameItem.filterBlock = ^(NSString *textValue) {
             @strongify(self);
            self.userTemp.userName = textValue;
            self.userTemp.username = textValue;
            return YES;
        };
    }
    return _nameItem;
}

- (DHTTableViewSection *) headSetion
{
    if (!_headSetion) {
        _headSetion = [DHTTableViewSection section];
        _headSetion.headerView = self.headView;
        _headSetion.headerHeight = 160;
    }
    return _headSetion;
}

- (TDFPickerItem *) roleItem
{
    if (!_roleItem) {
        _roleItem = [[TDFPickerItem alloc] init];
        _roleItem.title = NSLocalizedString(@"职级", nil);
        Role *role = [[Role alloc] init];
        if (self.employeeType == TDFEmployeeAdd) {
            NSString *lastRole=[[Platform Instance] getkey:DEFAULT_ROLE];
            if ([NSString isBlank:lastRole]) {
                if (self.roleList==nil || self.roleList.count<=1) {
                    role = nil;
                } else {
                    role = [self.roleList objectAtIndex:1];
                    self.userTemp.roleId = role.id;
                }
            } else {
                role.name = [GlobalRender obtainObjName:self.roleList itemId:lastRole];
                role._id = lastRole;
                self.userTemp.roleId = lastRole;
            }
        }else{
            if (self.employee.userVo.isSupper == 1) {
                role.name = NSLocalizedString(@"超级管理员", nil);
                role._id = @"0";
            } else {
                NSString* roleName=[GlobalRender obtainObjName:self.roleList itemId:self.employee.employeeVo.roleId];
                self.userTemp.roleId = self.employee.employeeVo.roleId;
                role.name = roleName;
                role._id = self.employee.employeeVo.roleId;
            }
        }
        _roleItem.textValue = role.name;
        _roleItem.preValue = role.name;
      
        TDFPAShowManagerStrategy *strategy = [[TDFPAShowManagerStrategy alloc] init];
        strategy.selectedItem = role;
        strategy.pickerName = NSLocalizedString(@"职级", nil);
        strategy.pickerItemList = self.roleList;
        _roleItem.strategy = strategy;
        strategy.managerName = NSLocalizedString(@"职级管理", nil);
        
        
        [strategy setManagerClickedBlock:^{
            TDFMediator *mediator = [[TDFMediator alloc] init];
            UIViewController *viewController = [mediator TDFMediator_chainRoleListViewController:self.entityId type:self.type editCallBack:^(BOOL orRefresh) {
            }];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    
          @weakify(self);
        _roleItem.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
            @strongify(self);
            self.userTemp.roleId = requestValue;
            [self.manager reloadData];
            return YES;
        };
    }
    return _roleItem;
}

- (NSMutableArray *)sexList {
    if(!_sexList) {
        _sexList = [NSMutableArray array];
        NameItemVO *item;
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"男", nil) andId:[NSString stringWithFormat:@"%d",1]];
        [_sexList addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"女", nil) andId:[NSString stringWithFormat:@"%d",2]];
        [_sexList addObject:item];
    }
    return _sexList;
}

#pragma 删除按钮点击
- (void) deleteAction
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.employee.employeeVo.name] event:10];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.imgCurrTag=actionSheet.tag;
    if (actionSheet.tag == 10) {
        //删除
        if (buttonIndex==0) {
            [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.employee.employeeVo.name]];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"entity_id"] = self.entityId;
            parma[@"employee_id"] = self.employeeId;
            
            @weakify(self);
            
            [[TDFChainService new] deleteEmployeeWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud hide:YES];
                self.employeeEditCallBack(YES);
                [self.navigationController popViewControllerAnimated:YES];
            }
                                                   failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                       @strongify(self);
                                                       [self.progressHud hide:YES];
                                                       [AlertBox show:error.localizedDescription];
                                                   }];
        }
        
    }else{
        //头像，身份证照片点击
        if (buttonIndex==0 || buttonIndex==1) {
            //获取点击按钮的标题
            if (buttonIndex==1)
            {
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [AlertBox show:NSLocalizedString(@"相机好像不能用哦!", nil)];
                    return;
                }
                NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                
                if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
                    imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
                    imagePickerController.delegate = self;
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }
                
            }
            else if(buttonIndex==0)
            {
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    [AlertBox show:NSLocalizedString(@"相册好像不能访问哦!", nil)];
                    return;
                }
                NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                
                if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
                    imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
                    imagePickerController.delegate = self;
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }
            }
        }
    }
}

#pragma 照片取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma 照片选择结束回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *fixedImage = [image fixOrientation];
        if ([ObjectUtil isNotNull:fixedImage]) {
            [self startUploadCustomerImage:fixedImage];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma 开始上传
- (void)startUploadCustomerImage:(UIImage *)image
{
    NSString* entityId=self.entityId;
    NSString* filePath=[NSString stringWithFormat:@"%@/employee/%@.png",entityId,[NSString getUniqueStrByUUID]];
    self.imgFilePathTemp=filePath;
    self.imgSelf=image;
    [self showProgressHudWithText:NSLocalizedString(@"正在上传图片", nil)];
    [[ServiceFactory Instance].systemService uploadImage:filePath image:image width:1280 heigth:1280 Target:self Callback:@selector(remotePortait:)];
}

//上传头像完成.
- (void)remotePortait:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    if (self.imgCurrTag == 1) {
        self.employeeVo.path = self.imgFilePathTemp;
        self.nameImageItem.avatarImage = self.imgSelf;
        self.nameImageItem.filePath = self.imgFilePathTemp;
    }else if(self.imgCurrTag == 2){
        self.employeeVo.frontPath = self.imgFilePathTemp;
        self.frontItem.cardImage = self.imgSelf;
        self.frontItem.cardImagePath = self.imgFilePathTemp;
    }else if (self.imgCurrTag == 3)
    {
        self.employeeVo.backPath = self.imgFilePathTemp;
        self.backItem.cardImage = self.imgSelf;
        self.backItem.cardImagePath = self.imgFilePathTemp;
    }
    [self.manager reloadData];
}

#pragma 解除绑定按钮点击
- (void) noBindBtnClick:(UIButton *)btn
{
    [MessageBox show:NSLocalizedString(@"确定要解除与这个二维火账户的绑定关系吗？解除绑定后，建议您更改此员工用户名，员工密码", nil) btnName:NSLocalizedString(@"确定", nil) client:self];
}

#pragma MessageBoxDelegate 实现
- (void)confirm
{
    if (self.memberExtend != nil) {
        [self unBindUser:self.memberExtend._id];
    }
}

//解绑
- (void)unBindUser:(NSString *)bindId
{
    [self showProgressHudWithText:NSLocalizedString(@"正在解绑", nil)];
    @weakify(self);
    [[[TDFUserService alloc] init] unBind:bindId sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        self.memberExtend = nil;
        self.headView = nil;
        self.headSetion.headerView = self.headView;
        [self.manager reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
         [AlertBox show:error.localizedDescription];
    }];
}

#pragma 判断项
- (BOOL)isValid
{
    if ([NSString isBlank:self.userTemp.roleId]) {
        [AlertBox show:NSLocalizedString(@"请选择职级!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:self.employeeVo.name]) {
        [AlertBox show:NSLocalizedString(@"请输入员工名称!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:self.userTemp.userName]) {
        [AlertBox show:NSLocalizedString(@"员工登录账号不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isNotNumAndLetter:self.userTemp.userName]) {
        [AlertBox show:NSLocalizedString(@"员工用户名只能是数字和字母", nil)];
        return NO;
    }
    
    if (self.employeeType == TDFEmployeeAdd) {
        return[self chkPwd];
    }
    return YES;
}

-(BOOL) chkPwd
{
    if ([NSString isBlank:self.userTemp.pwd]) {
        [AlertBox show:NSLocalizedString(@"系统登录密码不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:confirmPwd]) {
        [AlertBox show:NSLocalizedString(@"登录密码确认不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isNotNumAndLetter:self.userTemp.pwd]) {
        [AlertBox show:NSLocalizedString(@"系统登录密码只能是数字和英文字母!", nil)];
        return NO;
    }
    
    NSString * pwd = self.userTemp.pwd;
    if (![pwd isEqualToString:confirmPwd]) {
        [AlertBox show:NSLocalizedString(@"登录密码和密码确认不一样!", nil)];
        return NO;
    }
    return YES;
}

@end
