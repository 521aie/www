//
//  MemberSearchBar.m
//  RestApp
//
//  Created by xueyu on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

//
//  MemberSearchBar.m
//  RestApp
//
//  Created by xueyu on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberSearchBar.h"
#import "UIView+Sizes.h"
#import "NSString+Estimate.h"
#import "KeyBoardUtil.h"

@implementation MemberSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
 }

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]){
        [self initUI];
    }
    return self;
}

- (UIView *)panel {
    if(!_panel) {
        _panel = [[UIView alloc] init];
        _panel.backgroundColor = [UIColor clearColor];
        
        UIView *alpha = [[UIView alloc] init];
        alpha.backgroundColor = [UIColor blackColor];
        alpha.alpha = 0.3;
        alpha.layer.cornerRadius = 6;
        alpha.layer.masksToBounds = YES;
        [_panel addSubview:alpha];
        [alpha mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_panel);
        }];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"ico_search"];
        icon.alpha = 0.5;
        [_panel addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_panel.mas_left).with.offset(5);
            make.centerY.equalTo(_panel.mas_centerY);
            make.width.and.height.mas_equalTo(22);
        }];
        
        [_panel addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).with.offset(3);
            make.centerY.equalTo(_panel.mas_centerY);
            make.height.mas_equalTo(32);
            make.right.equalTo(_panel.mas_right).with.offset(5);
        }];
    }
    return _panel;
}

- (UITextField *)textField {
    if(!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = [UIColor whiteColor];
        _textField.keyboardType = UIKeyboardTypeWebSearch;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.keyboardAppearance = UIKeyboardAppearanceLight;
        _textField.delegate = self;
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"会员卡号/手机号", nil) attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.3],NSFontAttributeName :[UIFont systemFontOfSize:15]}];
        [KeyBoardUtil initWithTarget:_textField];

    }
    return _textField;
}

- (UIButton *)searchBtn {
    if(!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setTitle:NSLocalizedString(@"查询", nil) forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(void)initUI{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.1;
    
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.searchBtn];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
    }];
    
    [self addSubview:self.panel];
    [self.panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchBtn.mas_left);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(32);
    }];
}

//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//
//{
//    if (!textField.window.isKeyWindow)
//
// {
//    [textField.window makeKeyAndVisible];
// }
//}
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyBoard];
    NSString *keyword = textField.text;
    
    if ([NSString isNotBlank:keyword]) {
        
        [self.delegateTmp searchBarEventClick:keyword sender:nil];
    }
    return YES;
}
////// 隐藏键盘触发的方法
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSString *keyword = textField.text;
//
//    //    if ([NSString isBlank:keyword]) {
//    //
//    //        [self.delegateTmp searchBarEventClick:@""]];
//    //
//    //    } else {
//    //
////       [self.delegateTmp searchBarEventClick:keyword];
//    //    }
//
//}
-(void)hideKeyBoard:(UIView *)view{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [view addGestureRecognizer:tap];
    
}
-(void)hideKeyBoard{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)setSearchBarPlaceholder:(NSString *)text{
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.3],NSFontAttributeName :[UIFont boldSystemFontOfSize:15]}];
}

-(NSString *)getKeyword{

    return self.textField.text;
}

- (IBAction)searchAction:(id)sender {
    [self hideKeyBoard];
    if ([self.delegateTmp respondsToSelector:@selector(searchBarEventClick: sender:)])
    {
        [self.delegateTmp searchBarEventClick:self.textField.text sender:sender];
    }
}
@end


