//
//  loginView.h
//  LFYFormViewDemo
//
//  Created by 4DAGE_iMacMini on 2020/5/16.
//  Copyright © 2020 Lei.FY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FKFormView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,LoginType){
    LoginByPassword,         ///< 用户名密码登录
    LoginByAuthCode,         ///< 验证码登录
};

@class loginView;

@protocol FKLoginViewDelegate <NSObject>


/**
 忘记密码
 @param loginView 表单
 */
- (void)loginViewForgetPassword:(loginView *)loginView;

/**
 用户协议，隐私条款
 */
-(void)loginViewGoUserAgreement:(loginView *)loginView;

/**
 账号密码登录
 */

-(void)submitLoginByPhoneNumAndPassword:(NSString *)phoneNum password:(NSString *)password;

/**
 验证码登录
 */
-(void)submitLoginByPhoneNumAndAuthCode:(NSString *)phoneNum authCode:(NSString *)authCode;

@end


@interface loginView : UIView

@property (nonatomic,assign) LoginType    loginType ;         ///<登录方式切换

@property(nonatomic,weak)FKFormView  *formView;               ///< 封装的表单

@property (nonatomic, weak) id<FKLoginViewDelegate> delegate; ///< 代理


@end



#pragma mark - ViewController(loginView)

@interface ViewController(loginView)

@property(nonatomic,strong ,readonly)loginView *view;

@end

NS_ASSUME_NONNULL_END
