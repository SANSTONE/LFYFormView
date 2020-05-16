//
//  loginView.m
//  LFYFormViewDemo
//
//  Created by 4DAGE_iMacMini on 2020/5/16.
//  Copyright © 2020 Lei.FY. All rights reserved.
//

#import "loginView.h"

@interface loginView()<FKFormViewDelegate>

@end

@implementation loginView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:23/255. green:26/255. blue:26/255. alpha:1];
        [self addFormView];
    }
    return self;
}

-(void)addFormView{
    self.loginType = LoginByPassword;
    FKFormView *formView = [[FKFormView alloc]initWithFrame:CGRectZero
                                                submitTitle:@"确定"
                                                  formTitle:@"密码登录"
                                                   delegate:self];
    formView.formBottomType = FKFormBottomButtonTypeAll;
    formView.bottomTitles  = @[@"验证码登录",
                               @"忘记密码"];
    [self addSubview:formView];
    
    //需要设置表单项目section 默认是手机号码登录
    FKFormViewField *phoneField = [FKFormViewField fieldWithType:FKformViewFieldTypeInputWithLeftButton
                                                      identifier:@"userName"
                                                     placeholder:@"输入手机号"];
    phoneField.keyBoardType =UIKeyboardTypeNumberPad;
    FKFormViewField *passwordField = [FKFormViewField fieldWithType:FKFormViewFieldTypeInputAndPassword
                                                         identifier:@"password"
                                                        placeholder:@"输入密码"];
    passwordField.isSecurity = YES;
    
    FKFormViewSection *phoneSection = [FKFormViewSection sectionWithIdentifier:@"sectionsUserName" fields:@[phoneField]];
    phoneSection.title = @"手机号码";
    
    FKFormViewSection *passwordSection = [FKFormViewSection sectionWithIdentifier:@"sectionsPassword" fields:@[passwordField]];
    passwordSection.title = @"密码";
    
    formView.sections = @[phoneSection,passwordSection];
    
    // layout
    formView.frame =CGRectMake(30,
                               100,
                               [UIScreen mainScreen].bounds.size.width-80,
                               [UIScreen mainScreen].bounds.size.height-150);
    self.formView = formView;
    
}

#pragma mark - VEXFormViewDelegate

//底部左边按钮
- (void)formView:(FKFormView *)formView tapBottomleft:(NSArray<NSString *> *)titles tapType:(FKFormBottomButtonType)tapType{
   
    NSMutableArray<FKFormViewSection *> *sections = [[NSMutableArray alloc] init];
    switch (tapType) {
        case FKFormBottomButtonTypeLeft:
        {
            //切换到手机登录
            self.formView.formTitle = @"账号密码登录";
            self.formView.formBottomType = FKFormBottomButtonTypeAll;
            self.formView.bottomTitles  = @[@"验证码",
                                            @"忘记密码"];
            
            FKFormViewField *phoneField = [FKFormViewField fieldWithType:FKformViewFieldTypeInputWithLeftButton
                                                              identifier:@"userName"
                                                             placeholder:@"输入手机号码"];
            phoneField.keyBoardType =UIKeyboardTypeNumberPad;
            FKFormViewField *passwordField = [FKFormViewField fieldWithType:FKFormViewFieldTypeInputAndPassword
                                                                 identifier:@"password"
                                                                placeholder:@"输入密码"];
            passwordField.isSecurity = YES;
            
            FKFormViewSection *phoneSection = [FKFormViewSection sectionWithIdentifier:@"sectionsUserName" fields:@[phoneField]];
            phoneSection.title = @"手机号码";
            [sections addObject:phoneSection];

            FKFormViewSection *passwordSection = [FKFormViewSection sectionWithIdentifier:@"sectionsPassword" fields:@[passwordField]];
            passwordSection.title = @"密码";
            [sections addObject:passwordSection];
         
            self.formView.sections  = sections;
            self.loginType = LoginByPassword;
            break;
        }
        case FKFormBottomButtonTypeAll:   //验证码登录
        {
            //切换到验证码登录
            self.formView.formTitle = @"验证码登录";
            self.formView.formBottomType = FKFormBottomButtonTypeLeft;
            self.formView.bottomTitles = @[@"账号密码登录",];
            FKFormViewField *phoneField = [FKFormViewField fieldWithType:FKformViewFieldTypeInputWithLeftButton
                                                              identifier:@"veryfyPhone"
                                                             placeholder:@"手机号码"];
            phoneField.keyBoardType =UIKeyboardTypeNumberPad;
            FKFormViewSection *phoneSection = [FKFormViewSection sectionWithIdentifier:@"sectionVeryfyPhone"
                                                                            fields:@[phoneField]];
            phoneSection.title = @"手机号码";
            [sections addObject:phoneSection];

            FKFormViewField  *verifyCodeField = [FKFormViewField fieldWithType:FKFormViewFieldTypeInputWithRightButton
                                                                    identifier:@"verifyCodeField"
                                                                   placeholder:@"输入验证码"
                                                              rightButtonTitle:@"发送验证码"
                                                       rightButtonDisableTitle:[NSString stringWithFormat:@" %@ ",@"发送"]];
            verifyCodeField.keyBoardType =UIKeyboardTypeNumberPad;
            
            FKFormViewSection *verifyCodeSection = [FKFormViewSection sectionWithIdentifier:@"sectionVerifyCodeField"
                                                                                fields:@[verifyCodeField]];
            verifyCodeSection.title = @"验证码";
            
            [sections addObject:verifyCodeSection];
            
            self.formView.sections  = sections;
            self.loginType = LoginByAuthCode;
            break;
        }
            
        default:
            break;
    }
}

//底部右边按钮
- (void)formView:(FKFormView *)formView tapBottomRight:(NSArray<NSString *> *)titles tapType:(FKFormBottomButtonType)tapType{
    
    switch (tapType) {
        case FKFormBottomButtonTypeAll:   //验证码登录
        {
            //忘记密码 去重置密码新页面
            if ([self.delegate respondsToSelector:@selector(loginViewForgetPassword:)]) {
                [self.delegate loginViewForgetPassword:self];
            }
            break;
        }
            
        default:
            break;
    }
    
}

// 提交表单
- (void)formView:(FKFormView *)formView didSubmitWithSections:(NSArray<FKFormViewSection *> *)sections {
    
    if (self.loginType == LoginByPassword) {
        FKFormViewSection *phoneSection = [sections sectionForIdentifier:@"sectionsUserName"];
        NSString *phone  = [phoneSection.fields fieldForIdentifier:@"userName"].value;
        
        FKFormViewSection *passwordSection = [sections sectionForIdentifier:@"sectionsPassword"];
        NSString *password = [passwordSection.fields fieldForIdentifier:@"password"].value;
        
        if ([self.delegate respondsToSelector:@selector(submitLoginByPhoneNumAndPassword:password:)]) {
            [self.delegate submitLoginByPhoneNumAndPassword:phone password:password];
        }
    }
    
    if (self.loginType == LoginByAuthCode) {
        FKFormViewSection *phoneSection = [sections sectionForIdentifier:@"sectionVeryfyPhone"];
        NSString *phone  = [phoneSection.fields fieldForIdentifier:@"veryfyPhone"].value;
        
        FKFormViewSection *authCodeSection = [sections sectionForIdentifier:@"sectionVerifyCodeField"];
        NSString *authCode = [authCodeSection.fields fieldForIdentifier:@"verifyCodeField"].value;
        if ([self.delegate respondsToSelector:@selector(submitLoginByPhoneNumAndAuthCode:authCode:)]) {
            [self.delegate submitLoginByPhoneNumAndAuthCode:phone authCode:authCode];
        }
        
    }
}
@end

#pragma mark - ViewController(loginView)

@implementation  ViewController(loginView)

-(void)loadView{
    loginView *view = [[loginView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view  = view;
}

@end
